package controller.client;

import dao.AddressDAO;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Address;
import model.User;

@WebServlet(name = "AddressAPIController", urlPatterns = {"/api/address/add"})
public class AddressAPIController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        
        if (user == null) {
            out.print("{\"status\":\"error\", \"message\":\"Bạn chưa đăng nhập!\"}");
            return;
        }

        try {
            // Lấy data từ Ajax gửi lên
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String province = request.getParameter("province");
            String district = request.getParameter("district");
            String ward = request.getParameter("ward");
            String street = request.getParameter("street");
            int isDefault = Integer.parseInt(request.getParameter("isDefault"));

            Address a = new Address();
            a.setUserId(user.getUserId());
            a.setReceiverName(name);
            a.setReceiverPhone(phone);
            a.setProvince(province);
            a.setDistrict(district);
            a.setWard(ward);
            a.setDetailAddress(street);
            a.setIsDefault(isDefault);

            AddressDAO dao = new AddressDAO();
            int newId = dao.insertAddress(a);

            if (newId > 0) {
                // Trả về ID thật cho màn hình Checkout
                out.print("{\"status\":\"success\", \"newId\":" + newId + "}");
            } else {
                out.print("{\"status\":\"error\", \"message\":\"Lưu database thất bại!\"}");
            }
            
        } catch (Exception e) {
            out.print("{\"status\":\"error\", \"message\":\"Lỗi hệ thống: " + e.getMessage() + "\"}");
        }
    }
}