package controller.client;

import dao.ProductDAO;
import dao.CategoryDAO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Product;
import model.Category;

@WebServlet(name = "HomeController", urlPatterns = {"/home"})
public class HomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Set encoding để tránh lỗi font tiếng Việt khi chuyển trang
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        // 2. Gọi DAO lấy 5 sản phẩm đầu tiên (offset = 0)
        ProductDAO dao = new ProductDAO();
        List<Product> listProducts = dao.getProductsForHome(0);
        request.setAttribute("listProducts", listProducts);
        
        // 3. MỚI: Gọi CategoryDAO để lấy danh sách danh mục có ảnh
        CategoryDAO catDAO = new CategoryDAO();
        List<Category> listCategories = catDAO.getCategoriesForHome();
        request.setAttribute("listCategories", listCategories);
        
        // Khởi tạo DAO
        ProductDAO productDAO = new ProductDAO(); 
        
        // Bơm 5 sản phẩm Flash Sale ra ngoài JSP
        request.setAttribute("flashSaleList", productDAO.getFlashSaleProducts());
        
        // 4. Điều hướng tới giao diện trang chủ
        request.getRequestDispatcher("client/homepage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Trang chủ thường chỉ dùng GET để hiển thị, POST để trống hoặc gọi lại doGet
        doGet(request, response);
    }
}