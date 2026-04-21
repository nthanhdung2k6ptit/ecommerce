package controller.admin;

import dao.UserDAO;
import dao.VoucherDAO;
import java.io.IOException;
import java.math.BigDecimal;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Seller;
import model.User;
import model.Voucher;

/**
 * Controller quản lý Mã giảm giá (Voucher)
 * URL: /admin/Voucher?action=...
 */
@WebServlet(name = "AdminVoucherController", urlPatterns = {"/admin/Voucher"})
public class AdminVoucherController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedUser = checkAuth(request, response);
        if (loggedUser == null) return;

        int sellerId = getSellerIdFromSession(request, loggedUser);
        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            VoucherDAO voucherDAO = new VoucherDAO();

            switch (action) {
                case "edit": {
                    int id = Integer.parseInt(request.getParameter("id"));
                    Voucher v = voucherDAO.getVoucherById(id);
                    // Seller chỉ sửa voucher của mình
                    if (v != null && sellerId > 0 && v.getSellerId() != null && v.getSellerId() != sellerId) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN);
                        return;
                    }
                    request.setAttribute("editVoucher", v);
                    // fall through
                }
                default: {
                    java.util.List<Voucher> Voucher = (sellerId > 0)
                            ? voucherDAO.getVoucherBySeller(sellerId)
                            : voucherDAO.getAllVoucher();
                    request.setAttribute("Voucher", Voucher);
                    request.setAttribute("action", action);
                    request.getRequestDispatcher("/admin/manage_Voucher.jsp").forward(request, response);
                }
            }

        } catch (Exception e) {
            throw new ServletException("Lỗi quản lý voucher: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedUser = checkAuth(request, response);
        if (loggedUser == null) return;

        int sellerId = getSellerIdFromSession(request, loggedUser);
        String action = request.getParameter("action");

        try {
            VoucherDAO voucherDAO = new VoucherDAO();

            switch (action) {
                case "insert": {
                    Voucher v = buildVoucher(request, sellerId);
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
                    Voucher existing = voucherDAO.getVoucherById(id);
                    if (existing == null || (sellerId > 0 && existing.getSellerId() != null && existing.getSellerId() != sellerId)) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN);
                        return;
                    }
                    Voucher v = buildVoucher(request, sellerId);
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

        response.sendRedirect(request.getContextPath() + "/admin/Voucher");
    }

    private Voucher buildVoucher(HttpServletRequest req, int sellerId) {
        Voucher v = new Voucher();
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

    private User checkAuth(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User u = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (u == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return null;
        }
        if (!"admin".equals(u.getRole()) && !"seller".equals(u.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return null;
        }
        return u;
    }

    private int getSellerIdFromSession(HttpServletRequest request, User loggedUser) {
        if (isAdmin(loggedUser)) return -1;
        HttpSession session = request.getSession();
        Integer sid = (Integer) session.getAttribute("sellerId");
        if (sid != null) return sid;
        try {
            UserDAO userDAO = new UserDAO();
            Seller seller = userDAO.getSellerByUserId(loggedUser.getUserId());
            if (seller != null) {
                session.setAttribute("sellerId", seller.getSellerId());
                session.setAttribute("currentSeller", seller);
                return seller.getSellerId();
            }
        } catch (Exception e) { /* ignore */ }
        return -1;
    }

    private boolean isAdmin(User u) {
        return "admin".equals(u.getRole());
    }
}
