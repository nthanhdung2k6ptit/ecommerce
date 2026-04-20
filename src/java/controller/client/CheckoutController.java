package controller.client;

import dao.CartDAO;
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
import model.CartItemDTO;
import model.User;

@WebServlet(name = "CheckoutController", urlPatterns = {"/checkout"})
public class CheckoutController extends HttpServlet {

    // HIỂN THỊ TRANG THANH TOÁN
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Kéo giỏ hàng lên để hiển thị lại bill
        CartDAO cartDAO = new CartDAO();
        List<CartItemDTO> cartItems = cartDAO.getCartItems(user.getUserId());
        
        if (cartItems.isEmpty()) {
            // Giỏ hàng trống thì đuổi về trang chủ, không cho thanh toán
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Tính tổng tiền hàng
        BigDecimal subTotal = BigDecimal.ZERO;
        for (CartItemDTO item : cartItems) {
            subTotal = subTotal.add(item.getItemTotal());
        }

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("subTotal", subTotal);
        
        request.getRequestDispatcher("/client/checkout.jsp").forward(request, response);
    }

    // XỬ LÝ NÚT "ĐẶT HÀNG"
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 1. Nhận dữ liệu từ form giao diện
            int addressId = Integer.parseInt(request.getParameter("addressId"));
            String paymentMethod = request.getParameter("paymentMethod"); // 'cod', 'banking', 'e-wallet'
            
            // Xử lý Voucher (nếu có nhập thì lấy số, không thì để null)
            String voucherIdStr = request.getParameter("voucherId");
            Integer voucherId = (voucherIdStr != null && !voucherIdStr.trim().isEmpty()) ? Integer.parseInt(voucherIdStr) : null;

            // 2. BƯỚC BẢO MẬT: Tự tính lại tiền trên Backend, tuyệt đối không lấy tổng tiền từ Frontend gửi lên
            CartDAO cartDAO = new CartDAO();
            List<CartItemDTO> cartItems = cartDAO.getCartItems(user.getUserId());
            
            if (cartItems.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/cart/view");
                return;
            }

            BigDecimal totalAmount = BigDecimal.ZERO;
            for (CartItemDTO item : cartItems) {
                totalAmount = totalAmount.add(item.getItemTotal());
            }

            // Giả sử phí ship đồng giá là 30.000 VNĐ
            BigDecimal shippingFee = new BigDecimal("30000");
            totalAmount = totalAmount.add(shippingFee);

            // (Sau này nếu có logic giảm giá Voucher, em sẽ trừ tiền ở đoạn này)

            // 3. Gọi hàm Transaction để chốt sổ
            OrderDAO orderDAO = new OrderDAO();
            boolean isSuccess = orderDAO.placeOrder(user.getUserId(), addressId, voucherId, totalAmount, shippingFee, paymentMethod);

            if (isSuccess) {
                // Đặt hàng thành công -> Chuyển hướng sang trang Profile/Lịch sử đơn hàng
                response.sendRedirect(request.getContextPath() + "/client/profile.jsp?success=true");
            } else {
                // Thất bại (có thể do hết hàng) -> Quay lại báo lỗi
                response.getWriter().println("<h1>Giao dịch thất bại! Có thể sản phẩm đã hết hàng.</h1>");
            }

        } catch (Exception e) {
            System.err.println("Lỗi tại CheckoutController: " + e.getMessage());
            response.getWriter().println("<h1>Dữ liệu đầu vào không hợp lệ!</h1>");
        }
    }
}