package controller.admin;

import dao.VoucherDAO;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Users;
import model.Vouchers;

/**
 * Controller quản lý Mã giảm giá (Voucher)
 * URL: /admin/vouchers?action=...
 */
@WebServlet(name = "AdminVoucherController", urlPatterns = {"/admin/vouchers"})
public class AdminVoucherController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AdminProductController auth = new AdminProductController();
        Users loggedUser = auth.checkAuth(request, response);
        if (loggedUser == null) return;

        int sellerId = auth.getSellerIdFromSession(request, loggedUser);
        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            VoucherDAO voucherDAO = new VoucherDAO();

            switch (action) {
                case "edit": {
                    int id = Integer.parseInt(request.getParameter("id"));
                    Vouchers v = voucherDAO.getVoucherById(id);
                    // Seller chỉ sửa voucher của mình
                    if (v != null && sellerId > 0 && v.getSellerId() != null && v.getSellerId() != sellerId) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN);
                        return;
                    }
                    request.setAttribute("editVoucher", v);
                    // fall through
                }
                default: {
                    java.util.List<Vouchers> vouchers = (sellerId > 0)
                            ? voucherDAO.getVouchersBySeller(sellerId)
                            : voucherDAO.getAllVouchers();
                    request.setAttribute("vouchers", vouchers);
                    request.setAttribute("action", action);
                    request.getRequestDispatcher("/admin/manage_vouchers.jsp").forward(request, response);
                }
            }

        } catch (Exception e) {
            throw new ServletException("Lỗi quản lý voucher: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AdminProductController auth = new AdminProductController();
        Users loggedUser = auth.checkAuth(request, response);
        if (loggedUser == null) return;

        int sellerId = auth.getSellerIdFromSession(request, loggedUser);
        String action = request.getParameter("action");

        try {
            VoucherDAO voucherDAO = new VoucherDAO();

            switch (action) {
                case "insert": {
                    Vouchers v = buildVoucher(request, sellerId);
                    // Kiểm tra code trùng
                    if (voucherDAO.getVoucherByCode(v.getCode()) != null) {
                        request.getSession().setAttribute("msg", "❌ Mã giảm giá đã tồn tại!");
                    } else {
                        boolean ok = voucherDAO.insertVoucher(v);
                        request.getSession().setAttribute("msg",
                                ok ? "✅ Tạo mã giảm giá thành công!" : "❌ Tạo thất bại.");
                    }
                    break;
                }
                case "update": {
                    int id = Integer.parseInt(request.getParameter("voucherId"));
                    Vouchers existing = voucherDAO.getVoucherById(id);
                    if (existing == null || (sellerId > 0 && existing.getSellerId() != null && existing.getSellerId() != sellerId)) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN);
                        return;
                    }
                    Vouchers v = buildVoucher(request, sellerId);
                    v.setVoucherId(id);
                    boolean ok = voucherDAO.updateVoucher(v);
                    request.getSession().setAttribute("msg",
                            ok ? "✅ Cập nhật voucher thành công!" : "❌ Cập nhật thất bại.");
                    break;
                }
                case "delete": {
                    int id = Integer.parseInt(request.getParameter("voucherId"));
                    boolean ok = voucherDAO.deleteVoucher(id);
                    request.getSession().setAttribute("msg",
                            ok ? "✅ Xóa voucher thành công!" : "❌ Xóa thất bại.");
                    break;
                }
            }

        } catch (Exception e) {
            request.getSession().setAttribute("msg", "❌ Lỗi: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/vouchers");
    }

    private Vouchers buildVoucher(HttpServletRequest req, int sellerId) {
        Vouchers v = new Vouchers();
        v.setSellerId(sellerId > 0 ? sellerId : null);
        v.setCode(req.getParameter("code").toUpperCase().trim());
        v.setDiscountType(req.getParameter("discountType"));
        v.setDiscountValue(new BigDecimal(req.getParameter("discountValue")));
        String maxDisc = req.getParameter("maxDiscountValue");
        v.setMaxDiscountValue((maxDisc != null && !maxDisc.isEmpty()) ? new BigDecimal(maxDisc) : null);
        String minOrder = req.getParameter("minOrderValue");
        v.setMinOrderValue((minOrder != null && !minOrder.isEmpty()) ? new BigDecimal(minOrder) : BigDecimal.ZERO);
        String limit = req.getParameter("usageLimit");
        v.setUsageLimit((limit != null && !limit.isEmpty()) ? Integer.parseInt(limit) : 0);
        v.setStartDate(java.sql.Timestamp.valueOf(req.getParameter("startDate") + " 00:00:00"));
        v.setEndDate(java.sql.Timestamp.valueOf(req.getParameter("endDate") + " 23:59:59"));
        return v;
    }
}
