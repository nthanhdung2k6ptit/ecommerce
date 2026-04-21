package controller.admin;

import dao.OrderDAO;
import dao.UserDAO;
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
 * Controller quản lý Đơn hàng
 * URL: /admin/orders?action=...
 * action: list | detail | updateStatus
 */
@WebServlet(name = "AdminOrderController", urlPatterns = {"/admin/orders"})
public class AdminOrderController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedUser = checkAuth(request, response);
        if (loggedUser == null) return;

        int sellerId = getSellerIdFromSession(request, loggedUser);
        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            OrderDAO orderDAO = new OrderDAO();

            switch (action) {
                case "detail": {
                    int orderId = Integer.parseInt(request.getParameter("id"));
                    model.Order order = orderDAO.getOrderById(orderId);
                    if (order == null) {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND);
                        return;
                    }
                    // Seller chỉ được xem đơn của mình
                    if (sellerId > 0 && (order.getSellerId() == null || order.getSellerId() != sellerId)) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN);
                        return;
                    }
                    java.util.List<model.OrderItem> items = orderDAO.getOrderItems(orderId);
                    request.setAttribute("order", order);
                    request.setAttribute("orderItems", items);
                    request.setAttribute("action", "detail");
                    request.getRequestDispatcher("/admin/manage_orders.jsp").forward(request, response);
                    break;
                }
                default: { // list
                    String statusFilter = request.getParameter("status");
                    java.util.List<model.Order> orders;
                    if (statusFilter != null && !statusFilter.isEmpty()) {
                        orders = orderDAO.getOrdersByStatus(sellerId, statusFilter);
                        request.setAttribute("statusFilter", statusFilter);
                    } else {
                        orders = (sellerId > 0)
                                ? orderDAO.getOrdersBySeller(sellerId)
                                : orderDAO.getAllOrders();
                    }
                    request.setAttribute("orders", orders);
                    request.setAttribute("action", "list");
                    request.getRequestDispatcher("/admin/manage_orders.jsp").forward(request, response);
                }
            }

        } catch (Exception e) {
            throw new ServletException("Lỗi quản lý đơn hàng: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedUser = checkAuth(request, response);
        if (loggedUser == null) return;

        int sellerId = getSellerIdFromSession(request, loggedUser);
        String action = request.getParameter("action");

        try {
            OrderDAO orderDAO = new OrderDAO();

            if ("updateStatus".equals(action)) {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                String status = request.getParameter("status");
                // Seller chỉ có thể đổi đơn của mình
                model.Order order = orderDAO.getOrderById(orderId);
                if (order == null || (sellerId > 0 && (order.getSellerId() == null || order.getSellerId() != sellerId))) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                boolean ok = orderDAO.updateOrderStatus(orderId, status);
                request.getSession().setAttribute("msg",
                        ok ? "✅ Cập nhật trạng thái đơn hàng thành công!" : "❌ Cập nhật thất bại.");
            }

        } catch (Exception e) {
            request.getSession().setAttribute("msg", "❌ Lỗi: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/orders");
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

    private int getSellerIdFromSession(HttpServletRequest request, User loggedUser) {
        if (isAdmin(loggedUser)) return -1;
        HttpSession session = request.getSession();
        Integer sid = (Integer) session.getAttribute("sellerId");
        if (sid != null) return sid;
        try {
            UserDAO userDAO = new UserDAO();
            Seller seller = userDAO.getSellerByUserId(loggedUser.getUserId());
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
}
