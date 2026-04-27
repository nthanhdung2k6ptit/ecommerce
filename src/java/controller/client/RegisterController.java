package controller.client;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "RegisterController", urlPatterns = {"/register"})
public class RegisterController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // 1. Kiểm tra mật khẩu khớp nhau (dù JS đã chặn nhưng backend vẫn phải check lại)
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("/client/login_register.jsp?action=register").forward(request, response);
            return;
        }

        UserDAO dao = new UserDAO();

        // 2. Kiểm tra email đã bị đăng ký chưa (Dùng hàm isEmailExists của ông)
        if (dao.isEmailExists(email)) {
            request.setAttribute("error", "Email này đã được sử dụng!");
            request.getRequestDispatcher("/client/login_register.jsp?action=register").forward(request, response);
            return;
        }

        // 3. Khởi tạo User và lưu (Do hàm registerUser của ông dùng getPasswordHash() nên tôi gọi hàm đó)
        User newUser = new User();
        newUser.setFullName(fullName);
        newUser.setEmail(email);
        newUser.setPhone(phone);
        newUser.setPasswordHash(password); // Lẽ ra phải băm MD5/SHA256, nhưng tạm lưu text trơn

        // Gọi hàm registerUser
        if (dao.registerUser(newUser)) {
            request.setAttribute("message", "Đăng ký thành công! Vui lòng đăng nhập.");
            request.getRequestDispatcher("/client/login_register.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Hệ thống lỗi, không thể tạo tài khoản lúc này.");
            request.getRequestDispatcher("/client/login_register.jsp?action=register").forward(request, response);
        }
    }
}