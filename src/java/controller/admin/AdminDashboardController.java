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
import model.Seller;
import model.User;

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
        User account = getLoggedUser(session);
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String role = account.getRole();
        if (!"admin".equals(role) && !"seller".equals(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền truy cập");
            return;
        }

        try {
            int sellerId = -1; // -1 = admin (xem tất cả)

            // Nếu là seller, lấy seller_id
            if ("seller".equals(role)) {
                UserDAO userDAO = new UserDAO();
                Seller seller = userDAO.getSellerByUserId(account.getUserId());
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

            int totalProducts = productDAO.countProduct(sellerId);
            int totalOrders   = orderDAO.countOrders(sellerId);
            java.math.BigDecimal totalRevenue = orderDAO.getTotalRevenue(sellerId);
            int totalVouchers = voucherDAO.countVoucher(sellerId);

            // Admin thêm thống kê toàn sàn
            if ("admin".equals(role)) {
                int totalUser   = userDAO.countUsers();
                int totalSeller = userDAO.countSeller();
                request.setAttribute("totalUser", totalUser);
                request.setAttribute("totalSeller", totalSeller);
            }

            // 10 đơn hàng gần nhất
            java.util.List<model.Order> recentOrder = (sellerId > 0)
                    ? orderDAO.getOrdersBySeller(sellerId)
                    : orderDAO.getAllOrders();
            int take = Math.min(recentOrder.size(), 10);
            request.setAttribute("recentOrders", recentOrder.subList(0, take));

            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("totalOrders",   totalOrders);
            request.setAttribute("totalRevenue",   totalRevenue);
            request.setAttribute("totalVouchers",  totalVouchers);
            request.setAttribute("account",     account);
            request.setAttribute("sellerId",       sellerId);

            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Lỗi tải dashboard: " + e.getMessage(), e);
        }
    }

    private User getLoggedUser(HttpSession session) {
        if (session == null) return null;
        return (User) session.getAttribute("account");
    }
}
