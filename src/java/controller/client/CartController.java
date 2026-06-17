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

@WebServlet(name = "CartController", urlPatterns = {"/cart/add", "/cart/view", "/cart/remove", "/cart/update"})
public class CartController extends HttpServlet {

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

        String path = request.getServletPath();
        
        // LUỒNG XÓA SẢN PHẨM
        if ("/cart/remove".equals(path)) {
            try {
                int productId = Integer.parseInt(request.getParameter("productId"));
                CartDAO cartDAO = new CartDAO();
                cartDAO.removeCartItem(user.getUserId(), productId); 
            } catch (Exception e) {
                System.err.println("Lỗi xóa giỏ hàng: " + e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/cart/view");
            return;
        }
        
        // LUỒNG CẬP NHẬT SỐ LƯỢNG NGẦM (AJAX) - ĐÃ FIX CHẶN TỒN KHO
        if ("/cart/update".equals(path)) {
            response.setContentType("application/json;charset=UTF-8");
            try {
                int productId = Integer.parseInt(request.getParameter("productId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                CartDAO cartDAO = new CartDAO();
                
                // KIỂM TRA TỒN KHO
                int stock = cartDAO.getProductStock(productId);
                boolean adjusted = false;
                
                if (quantity > stock) {
                    quantity = stock; // Ép về mức tối đa
                    adjusted = true;
                }
                
                cartDAO.updateCartItemQuantity(user.getUserId(), productId, quantity);
                
                // Trả về JSON để Javascript biết đường hiện thông báo
                response.getWriter().print("{\"status\":\"success\", \"adjusted\":" + adjusted + ", \"maxStock\":" + stock + "}");
            } catch (Exception e) {
                response.getWriter().print("{\"status\":\"error\"}");
                System.err.println("Lỗi cập nhật số lượng: " + e.getMessage());
            }
            return; 
        }

        // LUỒNG XEM GIỎ HÀNG
        try {
            CartDAO cartDAO = new CartDAO();
            List<CartItemDTO> cartItems = cartDAO.getCartItems(user.getUserId());
            
            BigDecimal cartTotal = BigDecimal.ZERO;
            if (cartItems != null) {
                for (CartItemDTO item : cartItems) {
                    if (item.getItemTotal() != null) {
                        cartTotal = cartTotal.add(item.getItemTotal());
                    }
                }
            }

            request.setAttribute("cartItems", cartItems);
            request.setAttribute("cartTotal", cartTotal);
            request.getRequestDispatcher("/client/cart.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Lỗi hiển thị Giỏ hàng: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

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
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            CartDAO cartDAO = new CartDAO();
            
            // ========================================================
            // ĐÃ FIX: KIỂM TRA TỒN KHO TRƯỚC KHI THÊM VÀO GIỎ
            // ========================================================
            int stock = cartDAO.getProductStock(productId);
            int currentQtyInCart = cartDAO.getCartItemQuantity(user.getUserId(), productId);
            
            if (currentQtyInCart + quantity > stock) {
                // Vượt quá tồn kho -> Chặn lại và ném thông báo về Session
                request.getSession().setAttribute("msg", "❌ Số lượng sản phẩm trong kho không đủ! (Kho chỉ còn " + stock + ")");
                response.sendRedirect(request.getContextPath() + "/product_detail?id=" + productId);
                return;
            }

            boolean success = cartDAO.addToCart(user.getUserId(), productId, quantity);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/product_detail?id=" + productId + "&addSuccess=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
            
        } catch (Exception e) {
            System.err.println("Lỗi tại CartController POST: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}