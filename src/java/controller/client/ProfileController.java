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
                if ("completed".equals(o.getStatus())) {
                    completedCount++;
                    if (o.getTotalAmount() != null) {
                        totalSpent = totalSpent.add(o.getTotalAmount());
                    }
                }
            }

            // Xử lý format chữ K, M giống hệt logic JSP cũ của ông
            long spent = totalSpent.longValue();
            String spentStr = (spent >= 1000000) ? (spent / 1000000) + "M" 
                            : (spent >= 1000) ? (spent / 1000) + "K" 
                            : String.valueOf(spent);

            // 4. Bắt cờ thành công từ trang Checkout ném sang
            String successParam = request.getParameter("success");
            if ("true".equals(successParam)) {
                request.setAttribute("showSuccess", true);
            }

            // 5. Ném tất cả đồ chơi sang file JSP
            request.setAttribute("orders", orders);
            request.setAttribute("completedCount", completedCount);
            request.setAttribute("spentStr", spentStr);
            
            request.getRequestDispatcher("/client/profile.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Lỗi tại ProfileController: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}