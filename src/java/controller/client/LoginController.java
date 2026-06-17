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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/client/login_register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();
        // 1. Tìm user theo email trước
        User user = dao.findUserByEmail(email);

        if (user != null) {
            // 2. Kiểm tra tài khoản có bị khóa không
            if (!user.isIsActive()) {
                request.setAttribute("error", "Tài khoản của bạn đã bị khóa do vi phạm tiêu chuẩn cộng đồng!");
                request.getRequestDispatcher("/client/login_register.jsp").forward(request, response);
                return;
            }
            
            // 3. Kiểm tra mật khẩu (Giả sử ông check trực tiếp bằng string, nếu dùng hash thì phải dùng hàm verify)
            if (user.getPasswordHash().equals(password)) {
                HttpSession session = request.getSession();
                session.setAttribute("account", user); 
                if ("seller".equals(user.getRole())) {
                     session.setAttribute("currentSeller", dao.getSellerByUserId(user.getUserId()));
                }
                response.sendRedirect(request.getContextPath() + "/home");
            } else {
                request.setAttribute("error", "Email hoặc mật khẩu không chính xác!");
                request.getRequestDispatcher("/client/login_register.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Email hoặc mật khẩu không chính xác!");
            request.getRequestDispatcher("/client/login_register.jsp").forward(request, response);
        }
    }
}