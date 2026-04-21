package controller.admin;

import dao.OrderDAO;
import dao.ProductDAO;
import dao.UserDAO;
import dao.VoucherDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Sellers;
import model.Users;

/**
 * Controller trang Dashboard admin/seller
 * URL: /admin/dashboard
 */
@WebServlet(name = "AdminDashboardController", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra xác thực
        HttpSession session = request.getSession(false);
        Users loggedUser = getLoggedUser(session);
        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String role = loggedUser.getRole();
        if (!"admin".equals(role) && !"seller".equals(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền truy cập");
            return;
        }

        try {
            int sellerId = -1; // -1 = admin (xem tất cả)

            // Nếu là seller, lấy seller_id
            if ("seller".equals(role)) {
                UserDAO userDAO = new UserDAO();
                Sellers seller = userDAO.getSellerByUserId(loggedUser.getUserId());
                if (seller != null) {
                    sellerId = seller.getSellerId();
                    request.setAttribute("currentSeller", seller);
                }
            }

            // Lấy thống kê
            ProductDAO productDAO = new ProductDAO();
            OrderDAO orderDAO = new OrderDAO();
            VoucherDAO voucherDAO = new VoucherDAO();
            UserDAO userDAO = new UserDAO();

            int totalProducts = productDAO.countProducts(sellerId);
            int totalOrders   = orderDAO.countOrders(sellerId);
            java.math.BigDecimal totalRevenue = orderDAO.getTotalRevenue(sellerId);
            int totalVouchers = voucherDAO.countVouchers(sellerId);

            // Admin thêm thống kê toàn sàn
            if ("admin".equals(role)) {
                int totalUsers   = userDAO.countUsers();
                int totalSellers = userDAO.countSellers();
                request.setAttribute("totalUsers", totalUsers);
                request.setAttribute("totalSellers", totalSellers);
            }

            // 10 đơn hàng gần nhất
            java.util.List<model.Orders> recentOrders = (sellerId > 0)
                    ? orderDAO.getOrdersBySeller(sellerId)
                    : orderDAO.getAllOrders();
            int take = Math.min(recentOrders.size(), 10);
            request.setAttribute("recentOrders", recentOrders.subList(0, take));

            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("totalOrders",   totalOrders);
            request.setAttribute("totalRevenue",   totalRevenue);
            request.setAttribute("totalVouchers",  totalVouchers);
            request.setAttribute("loggedUser",     loggedUser);
            request.setAttribute("sellerId",       sellerId);

            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Lỗi tải dashboard: " + e.getMessage(), e);
        }
    }

    private Users getLoggedUser(HttpSession session) {
        if (session == null) return null;
        return (Users) session.getAttribute("loggedUser");
    }
}
