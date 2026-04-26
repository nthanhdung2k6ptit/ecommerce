package controller.admin;

import dao.CategoryDAO;
import dao.ProductDAO;
import java.io.IOException;
import java.math.BigDecimal;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Product;
import model.Seller;
import model.User;
import dao.UserDAO;

/**
 * Controller quản lý Sản phẩm
 * URL: /admin/Product?action=...
 * action: list | add | edit | insert | update | delete | updateStock
 */
@WebServlet(name = "AdminProductController", urlPatterns = {"/admin/products"})
public class AdminProductController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User account = checkAuth(request, response);
        if (account == null) return;

        int sellerId = getSellerIdFromSession(request, account);
        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            ProductDAO productDAO = new ProductDAO();
            CategoryDAO categoryDAO = new CategoryDAO();

            switch (action) {
                case "add":
                    request.setAttribute("categories", categoryDAO.getAllCategory());
                    request.setAttribute("action", "add");
                    request.getRequestDispatcher("/admin/manage_Product.jsp").forward(request, response);
                    break;

                case "edit":
                    int editId = Integer.parseInt(request.getParameter("id"));
                    Product p = productDAO.getProductById(editId);
                    if (p == null || (!isAdmin(account) && p.getSellerId() != sellerId)) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN);
                        return;
                    }
                    request.setAttribute("product", p);
                    request.setAttribute("categories", categoryDAO.getAllCategory());
                    request.setAttribute("action", "edit");
                    request.getRequestDispatcher("/admin/manage_Product.jsp").forward(request, response);
                    break;

                default: // list
                    String keyword = request.getParameter("keyword");
                    java.util.List<Product> productList;
                    if (keyword != null && !keyword.trim().isEmpty()) {
                        productList = productDAO.searchProduct(keyword.trim(), sellerId);
                        request.setAttribute("keyword", keyword);
                    } else {
                        productList = isAdmin(account)
                                ? productDAO.getAllProduct()
                                : productDAO.getProductBySeller(sellerId);
                    }
                    request.setAttribute("Product", productList);
                        request.setAttribute("categories", categoryDAO.getAllCategory());
                    request.setAttribute("action", "list");
                    request.getRequestDispatcher("/admin/manage_Product.jsp").forward(request, response);
            }

        } catch (Exception e) {
            throw new ServletException("Lỗi quản lý sản phẩm: " + e.getMessage(), e);
        }

        setCommonAttrs(request, account, sellerId);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User account = checkAuth(request, response);
        if (account == null) return;

        int sellerId = getSellerIdFromSession(request, account);
        String action = request.getParameter("action");

        try {
            ProductDAO productDAO = new ProductDAO();

            switch (action) {
                case "insert": {
                    Product p = buildProduct(request, sellerId);
                    boolean ok = productDAO.insertProduct(p);
                    request.getSession().setAttribute("msg",
                            ok ? "✅ Thêm sản phẩm thành công!" : "❌ Thêm sản phẩm thất bại.");
                    break;
                }
                case "update": {
                    int id = Integer.parseInt(request.getParameter("productId"));
                    // Seller chỉ được sửa sản phẩm của mình
                    Product existing = productDAO.getProductById(id);
                    if (existing == null || (!isAdmin(account) && existing.getSellerId() != sellerId)) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN);
                        return;
                    }
                    Product p = buildProduct(request, sellerId);
                    p.setProductId(id);
                    boolean ok = productDAO.updateProduct(p);
                    request.getSession().setAttribute("msg",
                            ok ? "✅ Cập nhật thành công!" : "❌ Cập nhật thất bại.");
                    break;
                }
                case "delete": {
                    int id = Integer.parseInt(request.getParameter("productId"));
                    Product existing = productDAO.getProductById(id);
                    if (existing == null || (!isAdmin(account) && existing.getSellerId() != sellerId)) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN);
                        return;
                    }
                    boolean ok = productDAO.deleteProduct(id);
                    request.getSession().setAttribute("msg",
                            ok ? "✅ Xóa sản phẩm thành công!" : "❌ Xóa thất bại.");
                    break;
                }
                case "updateStock": {
                    int id  = Integer.parseInt(request.getParameter("productId"));
                    int qty = Integer.parseInt(request.getParameter("quantity"));
                    productDAO.updateStock(id, qty);
                    request.getSession().setAttribute("msg", "✅ Cập nhật tồn kho thành công!");
                    break;
                }
            }

        } catch (Exception e) {
            request.getSession().setAttribute("msg", "❌ Lỗi: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/Product?action=list");
    }

    // ==================== HELPERS ====================

    private Product buildProduct(HttpServletRequest req, int sellerId) {
        Product p = new Product();
        p.setSellerId(sellerId > 0 ? sellerId : Integer.parseInt(req.getParameter("sellerId")));
        p.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
        p.setProductName(req.getParameter("productName"));
        p.setDescription(req.getParameter("description"));
        p.setBasePrice(new BigDecimal(req.getParameter("basePrice")));
        p.setStockQuantity(Integer.parseInt(req.getParameter("stockQuantity")));
        p.setImageUrl(req.getParameter("imageUrl"));
        p.setActive("true".equals(req.getParameter("isActive")));
        return p;
    }

    private User checkAuth(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User u = (session != null) ? (User) session.getAttribute("account") : null;
        if (u == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return null;
        }
        if (!"admin".equals(u.getRole()) && !"seller".equals(u.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return null;
        }
        return u;
    }

    private int getSellerIdFromSession(HttpServletRequest request, User account) {
        if (isAdmin(account)) return -1;
        HttpSession session = request.getSession();
        Integer sid = (Integer) session.getAttribute("sellerId");
        if (sid != null) return sid;
        try {
            UserDAO userDAO = new UserDAO();
            Seller seller = userDAO.getSellerByUserId(account.getUserId());
            if (seller != null) {
                session.setAttribute("sellerId", seller.getSellerId());
                session.setAttribute("currentSeller", seller);
                return seller.getSellerId();
            }
        } catch (Exception e) { /* ignore */ }
        return -1;
    }

    private boolean isAdmin(User u) {
        return "admin".equals(u.getRole());
    }

    private void setCommonAttrs(HttpServletRequest request, User account, int sellerId) {
        request.setAttribute("account", account);
        request.setAttribute("sellerId", sellerId);
    }
}
