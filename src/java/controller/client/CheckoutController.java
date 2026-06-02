package controller.client;

import dao.CartDAO;
import dao.OrderDAO;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
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
    private List<CartItemDTO> safeGetCheckoutItems(HttpSession session) {
        Object raw = session.getAttribute("checkoutItems");
        if (raw instanceof List<?>) {
            List<CartItemDTO> result = new ArrayList<>();
            for (Object o : (List<?>) raw) {
                if (o instanceof CartItemDTO) {
                    result.add((CartItemDTO) o);
                }
            }
            return result;
        }
        return new ArrayList<>();
    }

    private BigDecimal safeGetCheckoutSubTotal(HttpSession session) {
        Object raw = session.getAttribute("checkoutSubTotal");
        return (raw instanceof BigDecimal) ? (BigDecimal) raw : BigDecimal.ZERO;
    }

    // HIỂN THỊ TRANG THANH TOÁN
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Kéo giỏ hàng đã được lọc (chỉ những món được tick) từ Session lên (đọc an toàn)
        List<CartItemDTO> checkoutItems = safeGetCheckoutItems(session);
        BigDecimal subTotal = safeGetCheckoutSubTotal(session);

        if (checkoutItems.isEmpty()) {
            // Nếu không có gì để thanh toán thì đuổi về trang giỏ hàng
            response.sendRedirect(request.getContextPath() + "/cart/view");
            return;
        }

        // Truyền sang JSP để hiển thị
        request.setAttribute("checkoutItems", checkoutItems);
        request.setAttribute("subTotal", subTotal);
        
        request.getRequestDispatcher("/client/checkout.jsp").forward(request, response);
    }

    // XỬ LÝ NÚT BẤM (CẢ TỪ TRANG GIỎ HÀNG LẪN TRANG THANH TOÁN)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // =====================================================================
            // LUỒNG 1: Khách hàng bấm nút "Mua Hàng" từ trang Giỏ hàng (cart.jsp)
            // =====================================================================
            String[] selectedItemIds = request.getParameterValues("selectedItems");
            if (selectedItemIds != null && selectedItemIds.length > 0) {
                CartDAO cartDAO = new CartDAO();
                List<CartItemDTO> allCartItems = cartDAO.getCartItems(user.getUserId());
                List<CartItemDTO> checkoutItems = new ArrayList<>();
                BigDecimal subTotal = BigDecimal.ZERO;

                // Lọc ra ĐÚNG những món khách đã tick
                for (CartItemDTO item : allCartItems) {
                    for (String idStr : selectedItemIds) {
                        if (item.getProductId() == Integer.parseInt(idStr)) {
                            checkoutItems.add(item);
                            subTotal = subTotal.add(item.getItemTotal());
                            break;
                        }
                    }
                }

                // Lưu tạm vào Session để mang sang trang Checkout
                session.setAttribute("checkoutItems", checkoutItems);
                session.setAttribute("checkoutSubTotal", subTotal);
                
                // Dùng Redirect để chuyển sang hàm doGet bên trên hiển thị giao diện
                response.sendRedirect(request.getContextPath() + "/checkout");
                return;
            }

            // =====================================================================
            // LUỒNG 2: Khách hàng bấm nút "Đặt Hàng" ở trang Thanh toán (checkout.jsp)
            // =====================================================================
            String addressIdStr = request.getParameter("addressId");
            if (addressIdStr != null) {
                int addressId = Integer.parseInt(addressIdStr);
                String paymentMethod = request.getParameter("paymentMethod"); // 'cod', 'banking'
                
                String voucherIdStr = request.getParameter("voucherId");
                Integer voucherId = (voucherIdStr != null && !voucherIdStr.trim().isEmpty()) ? Integer.parseInt(voucherIdStr) : null;

                // Lấy lại danh sách hàng từ Session (đọc an toàn)
                List<CartItemDTO> checkoutItems = safeGetCheckoutItems(session);
                BigDecimal subTotal = safeGetCheckoutSubTotal(session);

                if (checkoutItems.isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/cart/view");
                    return;
                }

                // Tính toán phí ship và tổng cuối
                BigDecimal shippingFee = new BigDecimal("30000");
                BigDecimal totalAmount = subTotal.add(shippingFee);

                // GỌI DAO ĐỂ LƯU VÀO DATABASE
                OrderDAO orderDAO = new OrderDAO();
                
                // LƯU Ý QUAN TRỌNG TỚI ÔNG:
                // Tôi đã thêm biến `checkoutItems` vào hàm placeOrder. 
                // Ở OrderDAO, ông phải dùng List này để insert vào bảng order_items, chứ không được quét lại toàn bộ giỏ.
                boolean isSuccess = orderDAO.placeOrder(user.getUserId(), addressId, voucherId, totalAmount, shippingFee, paymentMethod, checkoutItems);

                if (isSuccess) {
                    // Chốt đơn xong thì dọn dẹp Session
                    session.removeAttribute("checkoutItems");
                    session.removeAttribute("checkoutSubTotal");
                    
                    // Chuyển về trang profile / báo thành công
                    response.sendRedirect(request.getContextPath() + "/profile?success=true");
                } else {
                    response.getWriter().println("<h1>Giao dịch thất bại! Có thể hệ thống bận.</h1>");
                }
                return;
            }

            // Nếu không lọt vào 2 luồng trên thì đá về giỏ hàng
            response.sendRedirect(request.getContextPath() + "/cart/view");

        } catch (Exception e) {
            System.err.println("Lỗi tại CheckoutController: " + e.getMessage());
            response.getWriter().println("<h1>Dữ liệu đầu vào không hợp lệ!</h1>");
        }
    }
}