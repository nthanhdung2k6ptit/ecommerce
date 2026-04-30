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

        // CHẾ ĐỘ MOCK LOGIN (Dùng tạm khi chưa kết nối DB)
        User user = null;
        if ("admin@test.com".equals(email) && "123456".equals(password)) {
            user = new User();
            user.setUserId(999);
            user.setFullName("Admin Giả Lập");
            user.setRole("admin");
            user.setIsActive(true);
        } else if ("seller@test.com".equals(email) && "123456".equals(password)) {
            user = new User();
            user.setUserId(888);
            user.setFullName("Shop Giả Lập");
            user.setRole("seller");
            user.setIsActive(true);
        } else {
            // Vẫn thử gọi DAO nếu bạn có bật DB sau này
            try {
                UserDAO dao = new UserDAO();
                user = dao.checkLogin(email, password);
            } catch (Exception e) { /* DB chưa sẵn sàng, bỏ qua */ }
        }

        if (user != null) {
            if (!user.isIsActive()) {
                request.setAttribute("error", "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ Admin!");
                request.getRequestDispatcher("/client/login_register.jsp").forward(request, response);
                return;
            }
            HttpSession session = request.getSession();
            
            session.setAttribute("account", user); 
            
            // Nếu là Seller thì lấy thêm thông tin shop để hiện ở Sidebar
            if ("seller".equals(user.getRole())) {
                 Seller sellerInfo = null;
                 if (user.getUserId() == 888) { // Shop Giả Lập
                     sellerInfo = new Seller(1, 888, "Khoa's Shop", "Shop bán hàng xịn");
                     sellerInfo.setApproved(true);
                 } else {
                     try {
                         UserDAO dao = new UserDAO();
                         sellerInfo = dao.getSellerByUserId(user.getUserId());
                     } catch (Exception e) {}
                 }
                 session.setAttribute("currentSeller", sellerInfo);
            }

            // Chuyển hướng dựa trên Role
            if ("admin".equals(user.getRole()) || "seller".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                // Trang chủ cho khách hàng
                response.sendRedirect(request.getContextPath() + "/client/homepage.jsp");
            }
        } else {
            // Sai thông tin đăng nhập
            request.setAttribute("error", "Email hoặc mật khẩu không chính xác!");
            request.getRequestDispatcher("/client/login_register.jsp").forward(request, response);
        }
    }
}