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

@WebServlet(name = "SearchController", urlPatterns = {"/search"})
public class SearchController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        // For GET requests Tomcat may not decode query-string as UTF-8 unless configured (URIEncoding).
        // Ensure parameters are interpreted as UTF-8 by re-decoding if necessary.
        request.setCharacterEncoding("UTF-8");

        String keyword = request.getParameter("keyword");
        if (keyword != null) {
            // Attempt to fix common mis-decoding when container treats query as ISO-8859-1
            try {
                keyword = new String(keyword.getBytes("ISO-8859-1"), "UTF-8");
            } catch (Exception ex) {
                // fallback: keep original
            }
        }

        if (keyword == null || keyword.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        ProductDAO dao = new ProductDAO();
        List<Product> results = dao.searchProduct(keyword.trim(), -1);

        // Diagnostic logging for debugging search behavior
        System.out.println("[SearchController] keyword='" + keyword + "' -> resultsCount=" + (results == null ? 0 : results.size()));

        request.setAttribute("listProducts", results);
        request.setAttribute("keyword", keyword.trim());
        request.getRequestDispatcher("client/homepage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
