<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
    // 세션을 무효화하여 로그아웃 처리
    if (session != null) {
        session.invalidate();  // 세션 무효화
    }

    // 로그아웃 후 메인 페이지로 리디렉션
    response.sendRedirect("main.jsp");
%>

~                                                                                                    
~                                                                                                    
~                                                                                                    
~                                                  