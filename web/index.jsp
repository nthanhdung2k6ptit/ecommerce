<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Tự động chuyển hướng vào trang chủ client (hoặc có thể trỏ vào admin tùy mục đích)
    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
%>
