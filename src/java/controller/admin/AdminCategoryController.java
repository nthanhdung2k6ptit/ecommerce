package controller.admin;

import dao.CategoryDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Category;
import model.User;

/**
 * Controller quản lý Danh mục sản phẩm
 * URL: /admin/categories?action=...
 */
@WebServlet(name = "AdminCategoryController", urlPatterns = {"/admin/categories"})
public class AdminCategoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedUser = checkAuth(request, response);
        if (loggedUser == null) return;

        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            CategoryDAO categoryDAO = new CategoryDAO();

            switch (action) {
                case "edit":
                    int id = Integer.parseInt(request.getParameter("id"));
                    Category cat = categoryDAO.getCategoryById(id);
                    request.setAttribute("editCategory", cat);
                    // fall through
                default:
                    request.setAttribute("categories", categoryDAO.getAllCategory());
                    request.setAttribute("rootCategories", categoryDAO.getRootCategory());
                    request.setAttribute("action", action);
                    request.getRequestDispatcher("/admin/manage_categories.jsp").forward(request, response);
            }

        } catch (Exception e) {
            throw new ServletException("Lỗi quản lý danh mục: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedUser = checkAuth(request, response);
        if (loggedUser == null) return;

        String action = request.getParameter("action");

        try {
            CategoryDAO categoryDAO = new CategoryDAO();

            switch (action) {
                case "insert": {
                    Category c = buildCategory(request);
                    boolean ok = categoryDAO.insertCategory(c);
                    request.getSession().setAttribute("msg",
                            ok ? "✅ Thêm danh mục thành công!" : "❌ Thêm thất bại.");
                    break;
                }
                case "update": {
                    Category c = buildCategory(request);
                    c.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
                    boolean ok = categoryDAO.updateCategory(c);
                    request.getSession().setAttribute("msg",
                            ok ? "✅ Cập nhật danh mục thành công!" : "❌ Cập nhật thất bại.");
                    break;
                }
                case "delete": {
                    int id = Integer.parseInt(request.getParameter("categoryId"));
                    boolean ok = categoryDAO.deleteCategory(id);
                    request.getSession().setAttribute("msg",
                            ok ? "✅ Xóa danh mục thành công!" : "❌ Xóa thất bại (có thể danh mục đang được dùng).");
                    break;
                }
            }

        } catch (Exception e) {
            request.getSession().setAttribute("msg", "❌ Lỗi: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }

    private Category buildCategory(HttpServletRequest req) {
        Category c = new Category();
        c.setCategoryName(req.getParameter("categoryName"));
        c.setDescription(req.getParameter("description"));
        String parentStr = req.getParameter("parentCategoryId");
        c.setParentCategoryId((parentStr != null && !parentStr.isEmpty()) ? Integer.parseInt(parentStr) : null);
        c.setImageUrl(req.getParameter("imageUrl"));
        return c;
    }

    private User checkAuth(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User u = (session != null) ? (User) session.getAttribute("loggedUser") : null;
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
}
