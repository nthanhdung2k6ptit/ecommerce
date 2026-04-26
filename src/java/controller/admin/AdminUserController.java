package controller.admin;

import dao.UserDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.User;

/**
 * Controller quản lý Tài khoản & Gian hàng (chỉ Admin)
 * URL: /admin/User?action=...
 */
@WebServlet(name = "AdminUserController", urlPatterns = {"/admin/users"})
public class AdminUserController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User account = checkAuth(request, response);
        if (account == null) return;

        // Chỉ Admin mới vào được trang này
        if (!"admin".equals(account.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Chỉ Admin mới có quyền quản lý tài khoản");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "User";

        try {
            UserDAO userDAO = new UserDAO();

            switch (action) {
                case "sellers":
                    request.setAttribute("sellers", userDAO.getAllSeller());
                    request.setAttribute("tab", "sellers");
                    break;
                default: // User
                    request.setAttribute("User", userDAO.getAllUsers());
                    request.setAttribute("tab", "User");
            }

            request.setAttribute("action", action);
            request.getRequestDispatcher("/admin/manage_User.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Lỗi quản lý tài khoản: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User account = checkAuth(request, response);
        if (account == null) return;

        if (!"admin".equals(account.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = request.getParameter("action");

        try {
            UserDAO userDAO = new UserDAO();

            switch (action) {
                case "updateRole": {
                    int userId = Integer.parseInt(request.getParameter("userId"));
                    String role = request.getParameter("role");
                    boolean ok = userDAO.updateUserRole(userId, role);
                    request.getSession().setAttribute("msg",
                            ok ? "✅ Phân quyền thành công!" : "❌ Phân quyền thất bại.");
                    response.sendRedirect(request.getContextPath() + "/admin/User?action=User");
                    return;
                }
                case "toggleActive": {
                    int userId  = Integer.parseInt(request.getParameter("userId"));
                    boolean active = "true".equals(request.getParameter("isActive"));
                    userDAO.updateUserActive(userId, active);
                    request.getSession().setAttribute("msg", "✅ Cập nhật trạng thái thành công!");
                    response.sendRedirect(request.getContextPath() + "/admin/User?action=User");
                    return;
                }
                case "approveSeller": {
                    int sellerId  = Integer.parseInt(request.getParameter("sellerId"));
                    boolean approved = "true".equals(request.getParameter("approved"));
                    userDAO.updateSellerApproval(sellerId, approved);
                    String msg = approved ? "✅ Đã duyệt shop!" : "⚠️ Đã từ chối shop.";
                    request.getSession().setAttribute("msg", msg);
                    response.sendRedirect(request.getContextPath() + "/admin/User?action=sellers");
                    return;
                }
                case "deleteSeller": {
                    int sellerId = Integer.parseInt(request.getParameter("sellerId"));
                    boolean ok = userDAO.deleteSeller(sellerId);
                    request.getSession().setAttribute("msg",
                            ok ? "✅ Đã xóa shop và hạ quyền chủ shop!" : "❌ Xóa shop thất bại.");
                    response.sendRedirect(request.getContextPath() + "/admin/User?action=sellers");
                    return;
                }
            }

        } catch (Exception e) {
            request.getSession().setAttribute("msg", "❌ Lỗi: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/User");
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
}
