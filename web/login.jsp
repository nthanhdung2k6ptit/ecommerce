<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Thay vì hiện các nút chọn Admin/Seller giả lập, 
    // ta chuyển hướng thẳng tới Controller xử lý đăng nhập thật.
    response.sendRedirect(request.getContextPath() + "/login");
%>
