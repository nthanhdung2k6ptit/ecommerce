package controller.client;

import dao.VoucherDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Voucher;
import java.text.DecimalFormat;

@WebServlet(name = "VoucherAPIController", urlPatterns = {"/api/voucher/check"})
public class VoucherAPIController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        String code = request.getParameter("code");
        String subTotalStr = request.getParameter("subTotal");
        
        if (code == null || subTotalStr == null) {
            out.print("{\"status\":\"error\", \"message\":\"Dữ liệu không hợp lệ!\"}");
            return;
        }

        try {
            BigDecimal subTotal = new BigDecimal(subTotalStr);
            VoucherDAO dao = new VoucherDAO();
            Voucher v = dao.getVoucherByCode(code.trim().toUpperCase());

            if (v == null) {
                out.print("{\"status\":\"error\", \"message\":\"Mã giảm giá không tồn tại!\"}");
                return;
            }
            if (v.getUsedCount() >= v.getUsageLimit()) {
                out.print("{\"status\":\"error\", \"message\":\"Mã giảm giá đã hết lượt sử dụng!\"}");
                return;
            }
            if (subTotal.compareTo(v.getMinOrderValue()) < 0) {
                // Tạo bộ format tiền tệ (cách nhau bằng dấu phẩy)
                DecimalFormat df = new DecimalFormat("#,###");
                String formattedMinOrder = df.format(v.getMinOrderValue());
                
                out.print("{\"status\":\"error\", \"message\":\"Đơn hàng chưa đủ điều kiện áp dụng mã này (Tối thiểu " + formattedMinOrder + "đ)!\"}");
                return;
            }

            // Tính tiền giảm
            BigDecimal discountAmount = BigDecimal.ZERO;
            if ("fixed".equals(v.getDiscountType())) {
                discountAmount = v.getDiscountValue();
            } else if ("percentage".equals(v.getDiscountType())) {
                discountAmount = subTotal.multiply(v.getDiscountValue()).divide(new BigDecimal("100"));
                if (v.getMaxDiscountValue() != null && discountAmount.compareTo(v.getMaxDiscountValue()) > 0) {
                    discountAmount = v.getMaxDiscountValue();
                }
            }

            // Trả về JSON cho Javascript
            out.print("{\"status\":\"success\", \"voucherId\":" + v.getVoucherId() + ", \"discountAmount\":" + discountAmount + ", \"message\":\"Áp dụng mã thành công!\"}");
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"status\":\"error\", \"message\":\"Lỗi hệ thống!\"}");
        }
    }
}