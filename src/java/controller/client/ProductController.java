package controller.client;

import dao.ProductDAO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Product;

// ĐIỂM QUAN TRỌNG NHẤT: Đổi urlPatterns thành "/products" để hết lỗi 404
@WebServlet(name = "ProductController", urlPatterns = {"/products"})
public class ProductController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        try {
            // 1. Hứng TOÀN BỘ các loại tham số có thể có trên URL
            String keyword = request.getParameter("keyword");       // Từ thanh tìm kiếm
            String minPrice = request.getParameter("minPrice");     // Từ bộ lọc giá
            String maxPrice = request.getParameter("maxPrice");
            String sort = request.getParameter("sort");             // Từ nút sắp xếp
            String categoryId = request.getParameter("categoryId"); // Từ danh mục ở trang chủ
            String pageStr = request.getParameter("page");          // Từ thanh phân trang

            // 2. Thiết lập cấu hình Phân trang
            int page = 1;
            int pageSize = 12; // Hiển thị 12 sản phẩm trên 1 trang
            if (pageStr != null && !pageStr.isEmpty()) {
                page = Integer.parseInt(pageStr);
            }

            // 3. Gọi DAO xử lý dữ liệu (Dùng 2 hàm đã nâng cấp ở bước trước)
            ProductDAO dao = new ProductDAO();
            List<Product> productList = dao.getFilteredProducts(keyword, minPrice, maxPrice, categoryId, sort, page, pageSize);
            int totalProducts = dao.countFilteredProducts(keyword, minPrice, maxPrice, categoryId);
            
            // Tính số lượng trang
            int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

            // 4. Trả lại toàn bộ trạng thái tham số cho JSP (Giữ lại những gì khách đã nhập/chọn)
            request.setAttribute("productList", productList);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            
            request.setAttribute("keyword", keyword);
            request.setAttribute("minPrice", minPrice);
            request.setAttribute("maxPrice", maxPrice);
            request.setAttribute("sort", sort);
            request.setAttribute("categoryId", categoryId); 

            // 5. Đẩy sang giao diện hiển thị
            request.getRequestDispatcher("/client/product.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Lỗi tại ProductController: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}