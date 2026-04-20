package controller.client;

import dao.CartDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "CartController", urlPatterns = {"/cart/add", "/cart/view"})
public class CartController extends HttpServlet {

    // Xử lý khi người dùng muốn XEM giỏ hàng
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Kiểm tra xem người dùng đã đăng nhập chưa
        HttpSession session = request.getSession();
        model.User user = (model.User) session.getAttribute("account");
        
        if (user == null) {
            // Chưa đăng nhập thì đuổi về trang login
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 2. Móc danh sách sản phẩm trong giỏ lên
        dao.CartDAO cartDAO = new dao.CartDAO();
        java.util.List<model.CartItemDTO> cartItems = cartDAO.getCartItems(user.getUserId());
        
        // 3. Tính toán Tổng tiền của cả giỏ hàng ngay tại Backend
        java.math.BigDecimal cartTotal = java.math.BigDecimal.ZERO;
        for (model.CartItemDTO item : cartItems) {
            cartTotal = cartTotal.add(item.getItemTotal());
        }

        // 4. Đóng gói dữ liệu gửi sang cho Frontend
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("cartTotal", cartTotal);
        
        // 5. Trỏ tới giao diện giỏ hàng
        request.getRequestDispatcher("/client/cart.jsp").forward(request, response);
    }

    // Xử lý khi người dùng bấm THÊM VÀO GIỎ
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Kiểm tra Session (Không có thẻ thông hành thì không cho mua)
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        
        if (user == null) {
            // Trả về mã lỗi 401 Unauthorized nếu dùng Ajax, hoặc redirect
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 2. Lấy ID sản phẩm và số lượng từ Frontend gửi lên
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            // 3. Gọi DAO để ném xuống MySQL
            CartDAO cartDAO = new CartDAO();
            boolean success = cartDAO.addToCart(user.getUserId(), productId, quantity);

            if (success) {
                // Thêm thành công thì chuyển hướng về trang xem giỏ hàng
                response.sendRedirect(request.getContextPath() + "/cart/view");
            } else {
                response.getWriter().println("Lỗi: Không thể thêm vào giỏ hàng.");
            }
            
        } catch (Exception e) {
            System.err.println("Lỗi tại CartController: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }
}