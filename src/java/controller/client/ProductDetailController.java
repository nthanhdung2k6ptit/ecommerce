package controller.client;

import dao.ProductDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Product;

@WebServlet(name = "ProductDetailController", urlPatterns = {"/product_detail"})
public class ProductDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        try {
            // 1. Tóm lấy ID sản phẩm từ URL
            String idRaw = request.getParameter("id");
            if (idRaw == null || idRaw.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
            int id = Integer.parseInt(idRaw);
            
            // 2. Gọi DAO móc dữ liệu (Hàm này ông đã viết sẵn cực xịn rồi)
            ProductDAO dao = new ProductDAO();
            Product p = dao.getProductById(id);
            
            if (p != null) {
                // THÊM ĐOẠN NÀY: Bắt cờ thành công từ CartController ném sang
                String addSuccess = request.getParameter("addSuccess");
                if ("true".equals(addSuccess)) {
                    request.setAttribute("addSuccess", true);
                }

                // 3. Đóng gói dữ liệu và ném sang JSP
                request.setAttribute("product", p);
                request.getRequestDispatcher("client/product_detail.jsp").forward(request, response);
            } else {
                // Khách gõ ID bậy bạ không có trong DB -> Đá về trang chủ
                response.sendRedirect(request.getContextPath() + "/home");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            // Lỗi ép kiểu (gõ chữ vào chỗ của số) -> Đá về trang chủ
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}