<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<h1>DB 연결 테스트</h1>
<%
    Connection conn = null;
    try {
        // DB 연결 정보 설정
        String dbURL = "jdbc:mariadb://10.240.2.201/yas";
        String dbUser = "root";
        String dbPassword = "password";

        // JDBC 드라이버 로드
        Class.forName("org.mariadb.jdbc.Driver");

        // DB 연결 시도
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // 연결 성공 메시지 출력
        out.println("<p>was-db Connection Success!</p>");
    } catch (Exception e) {
        // 예외 발생 시 오류 메시지 출력
        e.printStackTrace();
        out.println("<p>was-db Connection Failed: " + e.getMessage() + "</p>");
    } finally {
        // 연결이 성공했을 때 자원 해제
        if (conn != null) {
            try {
                conn.close();
                out.println("<p>Connection closed successfully.</p>");
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }
%>
