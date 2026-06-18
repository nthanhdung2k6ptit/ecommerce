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
        
        // LUỒNG CẬP NHẬT SỐ LƯỢNG NGẦM (AJAX) - TRONG GIỎ HÀNG
        if ("/cart/update".equals(path)) {
            response.setContentType("application/json;charset=UTF-8");
            try {
                int productId = Integer.parseInt(request.getParameter("productId"));
                
                // ĐÃ FIX BẢO MẬT: Chống nhập chữ cái
                int quantity = 1;
                try {
                    quantity = Integer.parseInt(request.getParameter("quantity"));
                    if (quantity <= 0) quantity = 1;
                } catch (NumberFormatException ex) {
                    quantity = 1; 
                }

                CartDAO cartDAO = new CartDAO();
                int stock = cartDAO.getProductStock(productId);
                boolean adjusted = false;
                
                if (quantity > stock) {
                    quantity = stock; 
                    adjusted = true;
                }
                
                cartDAO.updateCartItemQuantity(user.getUserId(), productId, quantity);
                response.getWriter().print("{\"status\":\"success\", \"adjusted\":" + adjusted + ", \"maxStock\":" + stock + "}");
            } catch (Exception e) {
                response.getWriter().print("{\"status\":\"error\"}");
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
            
            // ĐÃ FIX 404: Trả về file /cart.jsp gốc
            request.getRequestDispatcher("/client/cart.jsp").forward(request, response);
            
        } catch (Exception e) {
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
            
            // ĐÃ FIX BẢO MẬT: Bắt lỗi nếu người dùng gõ chữ cái ở trang chi tiết
            int quantity = 1;
            try {
                quantity = Integer.parseInt(request.getParameter("quantity"));
                if (quantity <= 0) quantity = 1; 
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("msg", "❌ Số lượng nhập vào không hợp lệ!");
                response.sendRedirect(request.getContextPath() + "/product_detail?id=" + productId);
                return;
            }
            
            String actionType = request.getParameter("actionType");
            CartDAO cartDAO = new CartDAO();
            
            int stock = cartDAO.getProductStock(productId);
            int currentQtyInCart = cartDAO.getCartItemQuantity(user.getUserId(), productId);
            
            if (currentQtyInCart + quantity > stock) {
                request.getSession().setAttribute("msg", "❌ Số lượng sản phẩm trong kho không đủ! (Kho chỉ còn " + stock + ")");
                response.sendRedirect(request.getContextPath() + "/product_detail?id=" + productId);
                return;
            }

            boolean success = cartDAO.addToCart(user.getUserId(), productId, quantity);

            if (success) {
                // ĐÃ FIX: Điều hướng Mua Ngay
                if ("buyNow".equals(actionType)) {
                    response.sendRedirect(request.getContextPath() + "/cart/view"); 
                } else {
                    response.sendRedirect(request.getContextPath() + "/product_detail?id=" + productId + "&addSuccess=true");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
            
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}