<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!--                
19번째 줄: 데이터베이스 연결 정보 (dbURL, dbUser, dbPassword)
170번째 줄: 로고 클릭 시 main.jsp로 이동
177번째 줄: HOTEL 클릭 시 order.jps로 이동
180번째 줄: CONTACT 클릭 시 reservation.jsp로 이동
185번째 줄: 로그인 클릭시 login.jsp로  이동
-->


<%
    // 회원가입 폼이 제출된 경우
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String loginid = request.getParameter("loginid");
        String loginpassword = request.getParameter("loginpassword");

        if (loginid != null && loginpassword != null) {
            String dbURL = "jdbc:mariadb://10.240.2.201/yas";
            String dbUser = "root";
            String dbPassword = "password";
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                Class.forName("org.mariadb.jdbc.Driver");
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                // 아이디가 이미 존재하는지 확인
                String checkUserSql = "SELECT COUNT(*) FROM users WHERE loginid = ?";
                pstmt = conn.prepareStatement(checkUserSql);
                pstmt.setString(1, loginid);
                rs = pstmt.executeQuery();

                if (rs.next() && rs.getInt(1) > 0) {
                    // 아이디가 이미 존재하면
                    out.println("<script>alert('이미 존재하는 아이디입니다. 다른 아이디를 사용해주세요.'); history.back();</script>");
                } else {
                    // 회원가입 진행
                    String insertUserSql = "INSERT INTO users (loginid, loginpassword) VALUES (?, ?)";
                    pstmt = conn.prepareStatement(insertUserSql);
                    pstmt.setString(1, loginid);
                    pstmt.setString(2, loginpassword);

                    int result = pstmt.executeUpdate();
                    if (result > 0) {
                        out.println("<script>alert('회원가입 성공!'); location.href='login.jsp';</script>");
                    } else {
                        out.println("<script>alert('회원가입 실패. 다시 시도해주세요.'); history.back();</script>");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<script>alert('오류 발생: " + e.getMessage() + "'); history.back();</script>");
            } finally {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            }
        }
    }
%>

<!doctype html>
<html lang="ko">
    <head>
        <title>펫토피아 회원가입</title>
        <meta charset="utf-8">
        <meta name="description" content="펫토피아 회원가입">
        <meta name="keywords" content="회원가입, 펫토피아">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <!-- 폰트어썸 -->
        <script src="https://kit.fontawesome.com/38a1e1c008.js" crossorigin="anonymous"></script>
    </head>
    <style>
        *{margin: 0 ; padding: 0 ; box-sizing: border-box; font-family: "SCDream", sans-serif;}
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
        ::-webkit-scrollbar {display: none;}
        .blind{left: -9999px; font-size: 0; position: absolute;}
        .center{max-width: 1823px; margin: 0 auto;}

        /* 회원가입 */
        .login_main { display: flex; }
        .leftBox { background-color: #fff1e1ab; width: 35%; height: 90vh; position: relative; }
        .leftBox .imgBox { background: url('./img/green_bg.png') no-repeat 0 0; height: 91.1vh; width: 100%; background-size: contain; background-position: bottom; text-align: center; position: relative; }
        .leftBox .imgBox img { width: 250px; position: absolute; transform: translate(-50%, -30%); bottom: 0; left: 50%; }
        .imgBox strong { font-size: 40px; position: absolute; width: 100%; left: 0; top: 26%; color: #545043; line-height: 70px; }

        .max-width600px { max-width: 600px; margin: 0 auto; text-align: left; }
        .loginBox { width: 65%; margin: 0 auto; padding-top: 10%; }
        .loginBox strong { font-size: 30px; font-weight: bold; }
        .loginBox form { margin: 0 auto; width: 100%; padding: 20px 0; }
        .input_form { margin-top: 10px; }
        .input_form input {
            width: 100%;
            padding: 0 15px;
            height: 50px;
            line-height: 48px;
            color: #252525;
            font-size: 14px;
            border: 1px solid #d1d1d1;
            border-radius: 6px;
            outline: 0;
            margin: 10px 0;
        }

        .joinbtn button {
            padding: 15px 10px;
            border-radius: 6px;
            margin: 0 auto;
            font-size: 18px;
            color: #fff;
            text-align: center;
            cursor: pointer;
            display: block;
            border: 0;
            width: 40%;
            font-weight: 800;
            background-color: #fbbc24;
            margin-top: 10%;
        }

        /* 헤더 */
        header {
            position: fixed;
            width: 100%;
            z-index: 500;
            transition: 0.35s;
        }
        header.white { background-color: #fff; height: 90px; padding: 10px 0; }
        .headerContainer { display: flex; max-width: 1640px; margin: 0 auto; justify-content: space-between; align-items: center; padding: 10px 0; }
        .blind { left: -9999px; font-size: 0; position: absolute; }
        header .tit_h1 { height: 100%; width: 70px; }
        header .tit_h1 a { background: url('./img/logo.png') no-repeat 0 0; height: 55px; width: 110px; display: block; background-size: contain; }

        .gnb { display: flex; width: 60%; justify-content: center; align-items: center; }
        .gnb li { text-align: center; padding-left: 80px; }
        .gnb li:first-child { padding: 0; }
        .gnb a { font-size: 24px; font-weight: 600; }

        .snb { display: flex; }
        .snb li { width: 100%; height: 100%; }
        .snb a { background: url('./img/login_icon.png') no-repeat 0 0; display: block; height: 35px; width: 35px; background-size: contain; }

        input[id="menuicon"] { display: none; }
        input[id="menuicon"] + label { display: block; position: relative; width: 70px; cursor: pointer; height: 30px; }
        input[id="menuicon"] + label span { position: absolute; width: 100%; background: #62432d; height: 4px; transform: translateY(-50%); transition: 0.2s; border-radius: 20px; }
        input[id="menuicon"] + label span:first-child { top: 0; width: 60%; right: 0; }
        input[id="menuicon"] + label span:nth-child(2) { top: 50%; left: 0; transform: translateY(-50%); }
        input[id="menuicon"] + label span:last-child { top: 100%; width: 70%; right: 0; }
    </style>

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
                    <li><a href="./order.jps">HOTEL</a></li>
                    <li><a href="#none">DOG TRAINING</a></li>
                    <li><a href="#none">SPA & BEAUTY</a></li>
                    <li><a href="./reservation.jsp">CONTACT</a></li>
                </ul>

                <ul class="snb">
                    <li>
                        <a href="./login.jsp" class="enter"></a>
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
            <div class="loginBox">
                <div class="max-width600px">
                    <strong>회원가입</strong>

                    <form method="post">
                        <table class="join">
                            <colgroup>
                                <col class="thw">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th class="th">아이디</th>
                                    <td class="input_form">
                                        <input type="text" id="loginid" name="loginid" autocomplete="off" class="inp_text" placeholder="아이디 입력" value="">
                                        <span id="idMsg">(영문소문자/숫자, 4~16자)</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th class="th">비밀번호</th>
                                    <td class="input_form">
                                        <input type="password" id="loginpassword" name="loginpassword" autocomplete="off" class="inp_text" placeholder="비밀번호 입력">
                                        <span id="idMsg">(영문 대소문자/숫자/특수문자 중 2가지 이상 조합, 10자~16자)</span>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <div class="joinbtn">
                            <button type="submit">회원가입</button>
                        </div>
                    </form>
                </div>
            </div>
        </section>
    </body>
</html>
