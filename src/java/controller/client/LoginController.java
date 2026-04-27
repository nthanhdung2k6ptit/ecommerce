package controller.client;

import dao.UserDAO;
import model.User;
import model.Seller;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginController", urlPatterns = {"/login"})
public class LoginController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();
        User user = dao.checkLogin(email, password);

        if (user != null) {
            HttpSession session = request.getSession();
            
            session.setAttribute("account", user); 
            
            // Nếu là Seller thì lấy thêm thông tin shop để hiện ở Sidebar
            if ("seller".equals(user.getRole())) {
                 Seller sellerInfo = dao.getSellerByUserId(user.getUserId());
                 session.setAttribute("currentSeller", sellerInfo);
            }

            // Chuyển hướng dựa trên Role
            if ("admin".equals(user.getRole()) || "seller".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                // Trang chủ cho khách hàng
                response.sendRedirect(request.getContextPath() + "/client/index.jsp");
            }
        } else {
            // Sai thông tin đăng nhập
            request.setAttribute("error", "Email hoặc mật khẩu không chính xác!");
            request.getRequestDispatcher("/client/login_register.jsp").forward(request, response);
        }
    }
}