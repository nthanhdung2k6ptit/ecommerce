<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Xóa session
    session.invalidate();
    response.sendRedirect(request.getContextPath() + "/login");
%>
