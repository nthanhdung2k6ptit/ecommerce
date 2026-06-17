package controller.client;

import dao.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Product;

@WebServlet(name = "LoadMoreController", urlPatterns = {"/loadMoreProducts"})
public class LoadMoreController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        // Lấy offset từ Javascript gửi lên
        int offset = Integer.parseInt(request.getParameter("offset"));
        
        ProductDAO dao = new ProductDAO();
        List<Product> list = dao.getProductsForHome(offset);
        
        PrintWriter out = response.getWriter();
        
        // Dùng vòng lặp in thẳng HTML trả về cho Ajax đắp vào giao diện
        for (Product p : list) {
            String imgHtml = "";
            String ctx = request.getContextPath();

            // ĐÃ FIX: Chỉ lấy trực tiếp URL từ Database hoặc Placeholder
            if (p.getImageUrl() == null || p.getImageUrl().isEmpty()) {
                imgHtml = "https://placehold.co/300x300?text=CDG+Marketplace";
            } else {
                imgHtml = p.getImageUrl(); // Không nối chuỗi /assets/img/ nữa
            }

            BigDecimal price = p.getBasePrice();
            String priceText = (price != null) ? String.format("%,d", price.longValue()).replace(',', '.') : "0";

            out.println("<a href=\"" + ctx + "/product_detail?id=" + p.getProductId() + "\" class=\"product-card-link\">");
            out.println("   <div class=\"product-card\">");
            out.println("       <div class=\"product-img\">");
            out.println("           <img src=\"" + imgHtml + "\" alt=\"" + p.getName() + "\">");
            out.println("       </div>");
            out.println("       <div class=\"product-info\">");
            out.println("           <div class=\"name\">" + p.getName() + "</div>");
            out.println("           <div class=\"price\">₫" + priceText + "</div>");
            out.println("           <div class=\"sold\">Kho: " + p.getStockQuantity() + "</div>");
            out.println("       </div>");
            out.println("   </div>");
            out.println("</a>");
        }
    }
}