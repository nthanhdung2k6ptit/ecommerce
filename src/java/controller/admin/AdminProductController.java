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
import model.Products;
import model.Sellers;
import model.Users;
import dao.UserDAO;

/**
 * Controller quản lý Sản phẩm
 * URL: /admin/products?action=...
 * action: list | add | edit | insert | update | delete | updateStock
 */
@WebServlet(name = "AdminProductController", urlPatterns = {"/admin/products"})
public class AdminProductController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Users loggedUser = checkAuth(request, response);
        if (loggedUser == null) return;

        int sellerId = getSellerIdFromSession(request, loggedUser);
        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            ProductDAO productDAO = new ProductDAO();
            CategoryDAO categoryDAO = new CategoryDAO();

            switch (action) {
                case "add":
                    request.setAttribute("categories", categoryDAO.getAllCategories());
                    request.setAttribute("action", "add");
                    request.getRequestDispatcher("/admin/manage_products.jsp").forward(request, response);
                    break;

                case "edit":
                    int editId = Integer.parseInt(request.getParameter("id"));
                    Products p = productDAO.getProductById(editId);
                    if (p == null || (!isAdmin(loggedUser) && p.getSellerId() != sellerId)) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN);
                        return;
                    }
                    request.setAttribute("product", p);
                    request.setAttribute("categories", categoryDAO.getAllCategories());
                    request.setAttribute("action", "edit");
                    request.getRequestDispatcher("/admin/manage_products.jsp").forward(request, response);
                    break;

                default: // list
                    String keyword = request.getParameter("keyword");
                    java.util.List<Products> productList;
                    if (keyword != null && !keyword.trim().isEmpty()) {
                        productList = productDAO.searchProducts(keyword.trim(), sellerId);
                        request.setAttribute("keyword", keyword);
                    } else {
                        productList = isAdmin(loggedUser)
                                ? productDAO.getAllProducts()
                                : productDAO.getProductsBySeller(sellerId);
                    }
                    request.setAttribute("products", productList);
                    request.setAttribute("categories", categoryDAO.getAllCategories());
                    request.setAttribute("action", "list");
                    request.getRequestDispatcher("/admin/manage_products.jsp").forward(request, response);
            }

        } catch (Exception e) {
            throw new ServletException("Lỗi quản lý sản phẩm: " + e.getMessage(), e);
        }

        setCommonAttrs(request, loggedUser, sellerId);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Users loggedUser = checkAuth(request, response);
        if (loggedUser == null) return;

        int sellerId = getSellerIdFromSession(request, loggedUser);
        String action = request.getParameter("action");

        try {
            ProductDAO productDAO = new ProductDAO();

            switch (action) {
                case "insert": {
                    Products p = buildProduct(request, sellerId);
                    boolean ok = productDAO.insertProduct(p);
                    request.getSession().setAttribute("msg",
                            ok ? "✅ Thêm sản phẩm thành công!" : "❌ Thêm sản phẩm thất bại.");
                    break;
                }
                case "update": {
                    int id = Integer.parseInt(request.getParameter("productId"));
                    // Seller chỉ được sửa sản phẩm của mình
                    Products existing = productDAO.getProductById(id);
                    if (existing == null || (!isAdmin(loggedUser) && existing.getSellerId() != sellerId)) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN);
                        return;
                    }
                    Products p = buildProduct(request, sellerId);
                    p.setProductId(id);
                    boolean ok = productDAO.updateProduct(p);
                    request.getSession().setAttribute("msg",
                            ok ? "✅ Cập nhật thành công!" : "❌ Cập nhật thất bại.");
                    break;
                }
                case "delete": {
                    int id = Integer.parseInt(request.getParameter("productId"));
                    Products existing = productDAO.getProductById(id);
                    if (existing == null || (!isAdmin(loggedUser) && existing.getSellerId() != sellerId)) {
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

        response.sendRedirect(request.getContextPath() + "/admin/products?action=list");
    }

    // ==================== HELPERS ====================

    private Products buildProduct(HttpServletRequest req, int sellerId) {
        Products p = new Products();
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

    Users checkAuth(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        Users u = (session != null) ? (Users) session.getAttribute("loggedUser") : null;
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

    int getSellerIdFromSession(HttpServletRequest request, Users loggedUser) {
        if (isAdmin(loggedUser)) return -1;
        HttpSession session = request.getSession();
        Integer sid = (Integer) session.getAttribute("sellerId");
        if (sid != null) return sid;
        try {
            UserDAO userDAO = new UserDAO();
            Sellers seller = userDAO.getSellerByUserId(loggedUser.getUserId());
            if (seller != null) {
                session.setAttribute("sellerId", seller.getSellerId());
                session.setAttribute("currentSeller", seller);
                return seller.getSellerId();
            }
        } catch (Exception e) { /* ignore */ }
        return -1;
    }

    private boolean isAdmin(Users u) {
        return "admin".equals(u.getRole());
    }

    private void setCommonAttrs(HttpServletRequest request, Users loggedUser, int sellerId) {
        request.setAttribute("loggedUser", loggedUser);
        request.setAttribute("sellerId", sellerId);
    }
}
