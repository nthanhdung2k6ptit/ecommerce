package controller.client;

import dao.CartDAO;
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

@WebServlet(name = "CartController", urlPatterns = {"/cart/add", "/cart/view"})
public class CartController extends HttpServlet {

    // ==========================================
    // 1. LUỒNG XEM GIỎ HÀNG (GET)
    // ==========================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Thiết lập chống lỗi font tiếng Việt
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        // Kiểm tra xem người dùng đã đăng nhập chưa
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        
        if (user == null) {
            // Chưa đăng nhập thì đuổi về trang login
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Móc danh sách sản phẩm trong giỏ lên
            CartDAO cartDAO = new CartDAO();
            List<CartItemDTO> cartItems = cartDAO.getCartItems(user.getUserId());
            
            // Tính toán Tổng tiền của cả giỏ hàng ngay tại Backend
            BigDecimal cartTotal = BigDecimal.ZERO;
            if (cartItems != null) {
                for (CartItemDTO item : cartItems) {
                    if (item.getItemTotal() != null) {
                        cartTotal = cartTotal.add(item.getItemTotal());
                    }
                }
            }

            // Đóng gói dữ liệu gửi sang cho Frontend
            request.setAttribute("cartItems", cartItems);
            request.setAttribute("cartTotal", cartTotal);
            
            // Trỏ tới giao diện giỏ hàng tĩnh
            request.getRequestDispatcher("/client/cart.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Lỗi hiển thị Giỏ hàng: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    // ==========================================
    // 2. LUỒNG THÊM VÀO GIỎ HÀNG (POST)
    // ==========================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Thiết lập chống lỗi font tiếng Việt
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        // Kiểm tra Session
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Lấy ID sản phẩm và số lượng từ Frontend gửi lên (từ file product_detail.jsp)
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            // Gọi DAO để ném xuống bảng carts và cart_items trong MySQL
            CartDAO cartDAO = new CartDAO();
            boolean success = cartDAO.addToCart(user.getUserId(), productId, quantity);

            if (success) {
                // Thêm thành công thì chuyển hướng về trang xem giỏ hàng bằng GET
                response.sendRedirect(request.getContextPath() + "/cart/view");
            } else {
                // Thêm thất bại thì đá về trang chủ (có thể làm trang báo lỗi sau)
                response.sendRedirect(request.getContextPath() + "/home");
            }
            
        } catch (NumberFormatException e) {
            System.err.println("Lỗi tham số đầu vào Giỏ hàng: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/home");
        } catch (Exception e) {
            System.err.println("Lỗi tại CartController POST: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}