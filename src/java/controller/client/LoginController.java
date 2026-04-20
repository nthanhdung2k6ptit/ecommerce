package controller.client;

import dao.UserDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.User;

// Đường dẫn này phải khớp với thuộc tính action="login" trong form HTML của Thành viên 2
@WebServlet(name = "LoginController", urlPatterns = {"/login"})
public class LoginController extends HttpServlet {

    /**
     * Hàm doGet xử lý khi người dùng gõ thẳng URL /login hoặc bấm link
     * Nhiệm vụ: Hiển thị trang giao diện đăng nhập
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Trỏ về file giao diện jsp của Frontend
        request.getRequestDispatcher("client/login_register.jsp").forward(request, response);
    }

    /**
     * Hàm doPost xử lý khi người dùng bấm nút "Submit" trên form Đăng nhập
     * Nhiệm vụ: Nhận dữ liệu, kiểm tra Database và tạo Session
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Ép kiểu tiếng Việt phòng trường hợp form gửi lên bị lỗi font
        request.setCharacterEncoding("UTF-8");

        // 2. Lấy dữ liệu từ các ô input của form HTML (name="email" và name="password")
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // 3. Gọi DAO để kiểm tra dưới CSDL
        UserDAO userDAO = new UserDAO();
        User user = userDAO.checkLogin(email, password);

        if (user != null) {
            // ĐĂNG NHẬP THÀNH CÔNG
            
            // 4. Lấy cái "ví" Session của trình duyệt hiện tại
            HttpSession session = request.getSession();
            
            // 5. Cất thẻ thông hành (object User) vào ví, đặt tên thẻ là "account"
            session.setAttribute("account", user);
            
            // 6. Điều hướng về Trang chủ (hoặc Dashboard nếu là Admin)
            if (user.getRole().equals("admin") || user.getRole().equals("seller")) {
                response.sendRedirect("admin/dashboard.jsp"); // Chủ sàn hoặc Chủ shop
            } else {
                response.sendRedirect("index.jsp"); // Khách hàng bình thường
            }
            
        } else {
            // ĐĂNG NHẬP THẤT BẠI
            
            // Báo lỗi và bắt đăng nhập lại
            request.setAttribute("errorMessage", "Email hoặc mật khẩu không chính xác!");
            request.getRequestDispatcher("client/login_register.jsp").forward(request, response);
        }
    }
}