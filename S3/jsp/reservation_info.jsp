<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!--
161번째 줄: 데이터베이스 연결 정보 설정 (dbURL, dbUser, dbPassword)
199번째 줄: SQL 쿼리 실행
170번째 줄: POST 요청 시 예약 삭제 처리 (reservation_id 파라미터로 삭제)
176번째 줄: SQL 쿼리 실행 (reservation_inquiry 테이블에서 예약 정보 조회)
222번째 줄: 삭제 버튼 클릭 시 예약 정보 삭제 처리
124번째 줄: 로고 클릭 시 main.jsp로 이동
139번째 줄: 로그인 클릭 시 login.jsp로 이동
-->

<!doctype html>
<html lang="ko">
    <head>
        <title>예약 정보 목록</title>
        <meta charset="utf-8">
        <meta name="description" content="예약 정보 조회 페이지">
        <meta name="keywords" content="예약 정보">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <!--폰트어썸-->
        <script src="https://kit.fontawesome.com/38a1e1c008.js" crossorigin="anonymous"></script>

        <style>
            /* 기본 스타일 */
            *{margin: 0; padding: 0; box-sizing: border-box; font-family: "SCDream", sans-serif;}
            ul, ol, li{list-style: none; vertical-align: middle;}
            a{text-decoration: none; color: #62432d;}
            body{
                overflow-x: hidden;
                font-family: 'Noto Sans KR', sans-serif;
                font-size: 14px;
                color: #333;
                letter-spacing: -1px;
                background-color: #fff9ed;
                overflow-y: scroll;
            }
            ::-webkit-scrollbar { display: none; }
            .blind { left: -9999px; font-size: 0; position: absolute; }
            .center { max-width: 1823px; margin: 0 auto; }

            /* 예약 정보 테이블 스타일 */
            .reservation-table {
                width: 100%;
                margin: 50px auto;
                border-collapse: collapse;
                text-align: left;
                background-color: #f9f9f9;
                border: 1px solid #eaeaea;
            }
            .reservation-table th, .reservation-table td {
                padding: 15px;
                border: 1px solid #eaeaea;
            }
            .reservation-table th {
                background-color: #fbbc24;
                color: #fff;
                font-weight: bold;
            }
            .reservation-table tr:nth-child(even) {
                background-color: #f7f7f7;
            }

            /* 삭제 버튼 스타일 */
            .delete-button {
                background-color: #ff4d4d;
                color: white;
                border: none;
                padding: 5px 10px;
                border-radius: 5px;
                cursor: pointer;
            }

            /* 돌아가기 버튼 스타일 */
            .go_back {
                margin: 20px auto;
                display: block;
                padding: 10px 20px;
                background-color: #fbbc24;
                color: white;
                text-align: center;
                border: none;
                border-radius: 5px;
                cursor: pointer;
            }

            /* 헤더 스타일 */
            header { position: fixed; width: 100%; z-index: 500; transition: 0.35s; }
            header.white { background-color: #fff; height: 90px; padding: 10px 0; }
            .headerContainer { display: flex; max-width: 1640px; margin: 0 auto; justify-content: space-between; align-items: center; padding: 10px 0; }
            header .tit_h1 { height: 100%; width: 70px; }
            header .tit_h1 a { background: url('./img/logo.png') no-repeat 0 0; height: 55px; width: 110px; display: block; background-size: contain; }

            .gnb {
                display: flex;
                width: 60%;
                justify-content: center;
                align-items: center;
            }
            .gnb li {
                text-align: center;
                padding-left: 80px;
            }
            .gnb li:first-child { padding: 0; }
            .gnb a { font-size: 24px; font-weight: 600; }

            .snb {
                display: flex;
            }
            .snb li { width: 100%; height: 100%; }
            .snb a { background: url('./img/login_icon.png') no-repeat 0 0; display: block; height: 35px; width: 35px; background-size: contain; }

            /* 예약 정보 섹션과 헤더 간의 마진 추가 */
            .content {
                margin-top: 120px;
            }
        </style>
    </head>
    <body>
        <header>
            <div class="headerContainer">
                <h1 class="tit_h1">
                    <a href="./main.jsp">
                        <span class="blind">로고</span>
                    </a>
                </h1>

                <ul class="gnb">
                    <li><a href="#none">DOG DAYCARE</a></li>
                    <li><a href="#none">HOTEL</a></li>
                    <li><a href="#none">DOG TRAINING</a></li>
                    <li><a href="#none">SPA & BEAUTY</a></li>
                    <li><a href="#none">CONTACT</a></li>
                </ul>

                <ul class="snb">
                    <li>
                        <a href="./login.jsp" class="enter"></a>
                    </li>
                </ul>
            </div>
        </header>

        <div class="center content">
            <h1>　        　　　　     　예약 정보 목록</h1>

            <table class="reservation-table">
                <thead>
                    <tr>
                        <th>예약 ID</th>
                        <th>문의 분류</th>
                        <th>성함</th>
                        <th>휴대폰번호</th>
                        <th>예약일</th>
                        <th>삭제</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        // 데이터베이스 연결
                        String dbURL = "jdbc:mariadb://10.240.2.201/yas?useUnicode=true&characterEncoding=UTF-8";
                        String dbUser = "root"; // 사용자 이름
                        String dbPassword = "password"; // 비밀번호
                        Connection conn = null;
                        Statement stmt = null;
                        ResultSet rs = null;

                        // 삭제 요청 처리
                        if ("POST".equalsIgnoreCase(request.getMethod())) {
                            String reservationId = request.getParameter("reservation_id");
                            PreparedStatement pstmt = null;

                            try {
                                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                                String deleteSQL = "DELETE FROM reservation_inquiry WHERE id = ?";
                                pstmt = conn.prepareStatement(deleteSQL);
                                pstmt.setInt(1, Integer.parseInt(reservationId));
                                int deleteResult = pstmt.executeUpdate();

                                if (deleteResult > 0) {
                                    out.println("<script>alert('삭제가 완료되었습니다.'); location.href='reservation_info.jsp';</script>");
                                } else {
                                    out.println("<script>alert('삭제에 실패했습니다. 다시 시도해주세요.'); history.back();</script>");
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                                out.println("<script>alert('오류가 발생했습니다: " + e.getMessage() + "'); history.back();</script>");
                            } finally {
                                if (pstmt != null) try { pstmt.close(); } catch (Exception e) { e.printStackTrace(); }
                            }
                        }

                        try {
                            // MariaDB 드라이버 로드
                            Class.forName("org.mariadb.jdbc.Driver");
                            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                            // SQL 쿼리 실행
                            String sql = "SELECT id, inquiry_type, name, phone, created_at FROM reservation_inquiry ORDER BY created_at DESC";
                            stmt = conn.createStatement();
                            rs = stmt.executeQuery(sql);

                            // 결과를 테이블로 출력
                            while (rs.next()) {
                                int id = rs.getInt("id");
                                String inquiryType = rs.getString("inquiry_type");
                                String name = rs.getString("name");
                                String phone = rs.getString("phone");
                                String createdAt = rs.getString("created_at");

                                %>
                                <tr>
                                    <td><%= id %></td>
                                    <td><%= inquiryType %></td>
                                    <td><%= name %></td>
                                    <td><%= phone %></td>
                                    <td><%= createdAt %></td>
                                    <td>
                                        <form method="post" action="">
                                            <input type="hidden" name="reservation_id" value="<%= id %>">
                                            <button type="submit" class="delete-button">삭제</button>
                                        </form>
                                    </td>
                                </tr>
                                <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            // 자원 정리
                            if (rs != null) try { rs.close(); } catch (Exception e) { e.printStackTrace(); }
                            if (stmt != null) try { stmt.close(); } catch (Exception e) { e.printStackTrace(); }
                            if (conn != null) try { conn.close(); } catch (Exception e) { e.printStackTrace(); }
                        }
                    %>
                </tbody>
            </table>

            <button class="go_back" onclick="window.history.back();">돌아가기</button>
        </div>
    </body>
</html>
