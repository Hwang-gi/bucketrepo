<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!--
22번째 줄: 로그인된 상태에서 로그아웃 시 logout.jsp로 이동
35번째 줄: MariaDB 드라이버 로드
36번째 줄: 데이터베이스 연결 정보 설정
52번째 줄: 로그인 성공 후 main.jsp로 리디렉션
347번째줄: 로고 클릭시에 main.jsp로 이동
354번째줄: hotel클릭시에 order.jsp로 이동
357번째줄: CONTACT 클릭시에 reservation.jsp로 이동
401번째줄: 회원가입 클릭시에 signup.jsp로 이동
-->     

<%
    // 세션에서 로그인 여부 확인
    String loginid = (String) session.getAttribute("loginid");

    // 만약 로그인된 상태라면 바로 logout.jsp로 리디렉션
    if (loginid != null) {
        response.sendRedirect("logout.jsp");
        return;
    }

    // 로그인 처리
    if (request.getMethod().equalsIgnoreCase("POST")) {
        loginid = request.getParameter("loginid");
        String loginpassword = request.getParameter("loginpassword");

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("org.mariadb.jdbc.Driver");
            String dbURL = "jdbc:mariadb://10.240.2.201/yas";
            String dbUser = "root"; // 사용자 이름
            String dbPassword = "password"; // 비밀번호
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            String sql = "SELECT * FROM users WHERE loginid = ? AND loginpassword = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, loginid);
            pstmt.setString(2, loginpassword);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                // 로그인 성공, 세션에 로그인 아이디 저장
                session.setAttribute("loginid", loginid); // 중복 선언 없이 세션에 저장

                // 로그인 성공 시 메인 페이지로 이동
                response.sendRedirect("main.jsp");
                return;
            } else {
                out.println("<script>alert('로그인 실패: 아이디 또는 비밀번호가 틀렸습니다.'); history.back();</script>");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) {}
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
    }
%>

<!doctype html>
<html lang="ko">
<head>
    <title>펫토피아 로그인</title>
    <meta charset="utf-8">
    <meta name="description" content="강아지 유치원 로그인">
    <meta name="keywords" content="로그인, 펫토피아">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- 폰트어썸 -->
    <script src="https://kit.fontawesome.com/38a1e1c008.js" crossorigin="anonymous"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: "SCDream", sans-serif;
        }
        ul, ol, li {
            list-style: none;
            vertical-align: middle;
        }
        a {
            text-decoration: none;
            color: #62432d;
        }
        body {
            overflow-x: hidden;
            font-family: 'Noto Sans KR', sans-serif;
            font-size: 14px;
            color: #333;
            letter-spacing: -1px;
            background-color: #fff9ed;
            overflow-y: scroll;
        }
        ::-webkit-scrollbar {
            display: none;
        }
        .blind {
            left: -9999px;
            font-size: 0;
            position: absolute;
        }
        .center {
            max-width: 1823px;
            margin: 0 auto;
        }

        /* 메인 페이지 */
        .login_main {
            display: flex;
        }
        .leftBox {
            background-color: #fff1e1ab;
            width: 35%;
            height: 90vh;
            position: relative;
        }
        .leftBox .imgBox {
            background: url('./img/green_bg.png') no-repeat 0 0;
            height: 91.1vh;
            width: 100%;
            background-size: contain;
            background-position: bottom;
            text-align: center;
            position: relative;
        }
        .leftBox .imgBox img {
            width: 250px;
            position: absolute;
            transform: translate(-50%, -30%);
            bottom: 0;
            left: 50%;
        }
        .imgBox strong {
            font-size: 40px;
            position: absolute;
            width: 100%;
            left: 0;
            top: 26%;
            color: #545043;
            line-height: 70px;
        }

        /* 로그인 박스 */
        .max-width460px {
            max-width: 460px;
            margin: 0 auto;
        }
        .loginBox {
            width: 65%;
            margin: 0 auto;
            padding-top: 10%;
        }
        .loginBox strong {
            font-size: 30px;
            font-weight: bold;
            text-align: left;
        }
        .loginBox form {
            margin: 0 auto;
            width: 100%;
            padding: 20px 0 20px 0;
        }
        .input_form {
            margin-top: 10px;
        }
        .input_form input {
            width: 100%;
            padding: 0 12px;
            height: 60px;
            line-height: 48px;
            color: #252525;
            font-size: 14px;
            letter-spacing: -0.7px;
            border: 1px solid #d1d1d1;
            border-radius: 6px;
            outline: 0;
        }

        .checkboxA {
            display: flex;
            justify-content: space-between;
            margin: 0 auto;
            width: 100%;
        }
        .checkboxA input {
            display: inline;
            cursor: pointer;
            height: 20px;
            width: 20px;
            border-radius: 50%;
            vertical-align: middle;
        }
        .checkboxA .find {
            font-size: 14px;
            padding-left: 50px;
        }

        .logBotton {
            display: flex;
            flex-direction: column;
            gap: 8px;
            margin-top: 40px;
            width: 100%;
        }
        .logBotton button {
            padding: 20px 80px;
            border-radius: 6px;
            margin: 0 auto;
            font-size: 20px;
            color: #fff;
            text-align: center;
            cursor: pointer;
            display: block;
            border: 0;
            width: 100%;
            font-weight: 800;
        }

        .logBotton button:first-child {
            background-color: #fbbc24;
        }
        .logBotton button:nth-child(2) {
            border: 1px solid #fbbc24;
            background-color: #ffffff;
            color: #fbbc24;
        }

        input[type="checkbox"]:checked {
            background-color: #9bcbff;
        }

        /* 헤더 */
        header {
            position: relative;
            width: 100%;
            height: 80px;
            background-color: rgb(255 255 255 / 0%);
            z-index: 500;
        }
        .headerContainer {
            display: flex;
            height: 80px;
            max-width: 1640px;
            margin: 0 auto;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0 10px 0;
        }
        .blind {
            left: -9999px;
            font-size: 0;
            position: absolute;
        }
        header .tit_h1 {
            height: 100%;
            width: 70px;
        }
        header .tit_h1 a {
            background: url('./img/logo.png') no-repeat 0 0;
            height: 60px;
            width: 110px;
            display: block;
            background-size: contain;
        }

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
        .gnb li:first-child {
            padding: 0;
        }
        .gnb a {
            font-size: 22px;
            font-weight: 600;
        }

        .snb {
            display: flex;
        }
        .snb li {
            width: 100%;
            height: 100%;
        }
        .snb a {
            background: url('./img/login_icon.png') no-repeat 0 0;
            display: block;
            height: 35px;
            width: 35px;
            background-size: contain;
        }

        input[id="menuicon"] {
            display: none;
        }
        input[id="menuicon"] + label {
            display: block;
            position: relative;
            width: 70px;
            cursor: pointer;
            height: 30px;
        }
        input[id="menuicon"] + label span {
            position: absolute;
            width: 100%;
            background: #62432d;
            height: 4px;
            transform: translateY(-50%);
            transition: 0.2s;
            border-radius: 20px;
        }
        input[id="menuicon"] + label span:first-child {
            top: 0;
            width: 60%;
            right: 0;
        }
        input[id="menuicon"] + label span:nth-child(2) {
            top: 50%;
            left: 0;
            transform: translateY(-50%);
        }
        input[id="menuicon"] + label span:last-child {
            top: 100%;
            width: 70%;
            right: 0;
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
                <li><a href="./order.jsp">HOTEL</a></li>
                <li><a href="#none">DOG TRAINING</a></li>
                <li><a href="#none">SPA & BEAUTY</a></li>
                <li><a href="./reservation.jsp">CONTACT</a></li>
            </ul>

            <ul class="snb">
                <li>
                    <a href="#none" class="enter"></a>
                </li>

                <input type="checkbox" id="menuicon" name="menuicon">
                <label for="menuicon">
                    <span></span>
                    <span></span>
                    <span></span>
                </label>
            </ul>
        </div>
    </header>

    <section class="login_main">
        <div class="leftBox">
            <div class="imgBox">
                <img src="./img/dog_person.png">
                <strong>댕댕이를 위한 프리미엄 케어, <br>회원제로 더 가까이!</strong>
            </div>
        </div>
        <div class="loginBox">
            <div class="max-width460px">
                <strong>Login</strong>
                <form method="post">
                    <div class="input_form">
                        <input type="text" id="loginid" name="loginid" autocomplete="off" placeholder="아이디 입력">
                    </div>
                    <div class="input_form">
                        <input type="password" id="loginpassword" name="loginpassword" autocomplete="off" placeholder="비밀번호 입력 (영문, 숫자, 특수문자 조합)">
                    </div>
                    <div class="checkboxA">
                        <div class="checkbox01">
                            <input type="checkbox" id="i_saveid" name="i_saveid">
                            <label for="i_saveid"> 아이디 저장 </label>
                        </div>
                        <a href="#none" class="find">아이디/비밀번호 찾기</a>
                    </div>
                    <div class="logBotton">
                        <button type="submit">로그인</button>
                        <button type="button" onclick="location.href='./signup.jsp';">회원가입</button>
                    </div>
                </form>
            </div>
        </div>
    </section>
</body>
</html>
