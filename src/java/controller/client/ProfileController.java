package controller.client;

import dao.OrderDAO;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Order;
import model.User;

@WebServlet(name = "ProfileController", urlPatterns = {"/profile"})
public class ProfileController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        // 1. Kiểm tra đăng nhập
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 2. Lấy danh sách lịch sử đơn hàng
            OrderDAO orderDAO = new OrderDAO();
            List<Order> orders = orderDAO.getOrdersByUser(account.getUserId());

            // 3. Tính toán số liệu thống kê (Đơn hoàn thành & Tổng tiền đã chi)
            long completedCount = 0;
            BigDecimal totalSpent = BigDecimal.ZERO;

            for (Order o : orders) {
                // Nhận diện trạng thái "delivered" hoặc "completed"
                if ("delivered".equalsIgnoreCase(o.getStatus()) || "completed".equalsIgnoreCase(o.getStatus())) {
                    completedCount++;
                    if (o.getTotalAmount() != null) {
                        totalSpent = totalSpent.add(o.getTotalAmount());
                    }
                }
            }

            // 4. Bắt cờ thành công từ trang Checkout
            String successParam = request.getParameter("success");
            if ("true".equals(successParam)) {
                request.setAttribute("showSuccess", true);
            }

            // 5. Ném dữ liệu sang file JSP (Truyền thẳng số tiền thay vì chữ M/K)
            request.setAttribute("orders", orders);
            request.setAttribute("completedCount", completedCount);
            request.setAttribute("totalSpent", totalSpent);
            
            request.getRequestDispatcher("/client/profile.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Lỗi tại ProfileController: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}