package controller.admin;

import dao.OrderDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Users;

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

        AdminProductController auth = new AdminProductController();
        Users loggedUser = auth.checkAuth(request, response);
        if (loggedUser == null) return;

        int sellerId = auth.getSellerIdFromSession(request, loggedUser);
        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            OrderDAO orderDAO = new OrderDAO();

            switch (action) {
                case "detail": {
                    int orderId = Integer.parseInt(request.getParameter("id"));
                    model.Orders order = orderDAO.getOrderById(orderId);
                    if (order == null) {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND);
                        return;
                    }
                    // Seller chỉ được xem đơn của mình
                    if (sellerId > 0 && order.getSellerId() != sellerId) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN);
                        return;
                    }
                    java.util.List<model.Order_Items> items = orderDAO.getOrderItems(orderId);
                    request.setAttribute("order", order);
                    request.setAttribute("orderItems", items);
                    request.setAttribute("action", "detail");
                    request.getRequestDispatcher("/admin/manage_orders.jsp").forward(request, response);
                    break;
                }
                default: { // list
                    String statusFilter = request.getParameter("status");
                    java.util.List<model.Orders> orders;
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

        AdminProductController auth = new AdminProductController();
        Users loggedUser = auth.checkAuth(request, response);
        if (loggedUser == null) return;

        int sellerId = auth.getSellerIdFromSession(request, loggedUser);
        String action = request.getParameter("action");

        try {
            OrderDAO orderDAO = new OrderDAO();

            if ("updateStatus".equals(action)) {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                String status = request.getParameter("status");
                // Seller chỉ có thể đổi đơn của mình
                model.Orders order = orderDAO.getOrderById(orderId);
                if (order == null || (sellerId > 0 && order.getSellerId() != sellerId)) {
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
}
