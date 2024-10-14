<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<!--                
23번째 줄: 데이터베이스 연결 정보 (dbURL, dbUser, dbPassword)
37번째 줄: MariaDB 드라이버 로드
42번째 줄: 데이터베이스 연결
55번째 줄: 예약 성공 시 main.jsp로 리디렉션
57번째 줄: 실패 시 다시 시도 메시지와 history.back() 호출
                    
202번째 줄: 로고 클릭 시 main.jsp로 이동
209번째 줄: HOTEL 클릭 시 order.jps로 이동
212번째 줄: CONTACT 클릭 시 reservation.jsp로 이동
217번째 줄: 로그인버튼클릭시 login.jsp로 이동
-->             

<%     
    // POST 요청 시 데이터 처리
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        request.setCharacterEncoding("UTF-8");

        // 데이터베이스 연결 정보
        String dbURL = "jdbc:mariadb://10.240.2.201/yas?useUnicode=true&characterEncoding=UTF-8";
        String dbUser = "root";  // 데이터베이스 사용자 이름
        String dbPassword = "password";  // 데이터베이스 비밀번호

        // 폼으로부터 전달받은 값
        String inquiryType = request.getParameter("inquiry_type");
        String name = request.getParameter("name");
        String phoneCode = request.getParameter("phone_code");
        String phoneNum = request.getParameter("phoneNum");
        String phone = phoneCode + "-" + phoneNum;  // 최종 휴대폰번호 형식

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // MariaDB 드라이버 로드
            Class.forName("org.mariadb.jdbc.Driver");

            // 데이터베이스 연결
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            // SQL INSERT 쿼리 준비
            String sql = "INSERT INTO reservation_inquiry (inquiry_type, name, phone) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, inquiryType);
            pstmt.setString(2, name);
            pstmt.setString(3, phone);

            // 쿼리 실행
            int result = pstmt.executeUpdate();

            if (result > 0) {
                out.println("<script>alert('예약이 완료되었습니다.'); location.href='main.jsp';</script>");
            } else {
                out.println("<script>alert('예약에 실패했습니다. 다시 시도해주세요.'); history.back();</script>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('오류가 발생했습니다: " + e.getMessage() + "'); history.back();</script>");
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
    }
%>

<!doctype html>
<html lang="ko">
    <head>
        <title>펫토피아</title>
        <meta charset="utf-8">
        <meta name="description" content="강아지 유치원">
        <meta name="keywords" content="강아지유치원,강아지호텔">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

        <!--폰트어썸-->
        <script src="https://kit.fontawesome.com/38a1e1c008.js" crossorigin="anonymous"></script>
    </head>
    <style>
        /* 스타일 부분은 그대로 유지 */
        *{margin: 0 ; padding: 0 ; box-sizing: border-box; font-family: "SCDream", sans-serif;}
        ul,ol,li{list-style: none;vertical-align: middle;}
        a{text-decoration: none;color: #62432d;}
        body{
            overflow-x:hidden;
            font-family: 'Noto Sans KR', sans-serif;
            font-size: 14px;
            color: #333;
            letter-spacing: -1px;
            background-color: #fff9ed;
            overflow-y: scroll;}
        ::-webkit-scrollbar {display: none;}
        .blind{left: -9999px; font-size: 0; position: absolute;}
        .center{max-width: 1823px; margin: 0 auto;}
        #board{margin-bottom: 160px;}
        #board .con_01Wrap{text-align: center;padding-top: 150px;}
        #board .con_01Wrap .topText{padding-bottom: 40px;}
        #board .con_01Wrap h1{ font-size: 40px; font-weight: 700;}
        #board .caption{padding-bottom: 100px;}
        #board .caption p{font-size: 28px;font-weight: 500;}
        #board .caption p span{color: #fbbc24;font-weight: 700;}
        #board .flex{display: flex;}
        #board .InquiryBox{margin: auto;max-width: 1200px;}
        #board #contact{
            background: url('img/arrow-down-sign-to-navigate.png') no-repeat right;
            background-size: 20px;
            background-position: 95%;
            border-radius: 0px;
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
        }
        #board .thw{width: 10%;}
        #board table tbody tr th{font-size:18px; white-space: nowrap;text-align: left;}
        #board table tbody tr th::after{content: "*";color: #fbbc24;position: relative;bottom: 15px;left: 9px;display: inline-block;}
        #board table tbody tr td{padding:0 15px;}
        #board table tbody #contact{width: 100%;height: 50px;font-size: 18px;color: #666;border: 1px solid #eaeaea7a;border-radius: 6px;padding: 2px 20px;margin: 14px 5px;outline: 0;background: #fff;}
        #board table input{width: 100%;font-size: 20px;color: #666;border-radius: 6px;border: 1px solid #eaeaea7a;padding: 25px 20px;margin: 14px 5px;height: 50px;outline: 0;background-color: #ffffff;}
        td span{font-size: 17px;color: #fbbc24;line-height: 30px;padding: 0 5px;position: relative;top:30px;}
        .backgray{background: #f7f8fb; border:1px solid #f7f8fb !important;}
        #board textarea{resize: none;width: 100%;color: #666;border-radius: 15px;border: 1px solid #eaeaea7a;height: 100%;padding: 25px 20px;margin: 14px 5px;height: 320px;outline: 0;font-size: 21px;}
        .sumbit_wrap{padding-top: 100px;}
        .sumbit_wrap button{
            background: #fbbc24;
            padding: 20px 80px;
            border-radius: 15px;
            margin: 0 auto;
            font-size: 20px;
            color: #fff;
            text-align: center;
            cursor: pointer;
            display: block;
            border: 0;
            font-weight: bold;
        }
        .agree{padding-bottom: 30px;}
        #board #checkbox{height: 25px; width: 25px; }
        #board label{line-height: 46px;position: relative;top: 19px;}
        #board table tbody tr .none::after{display: none;}
        header{position: fixed;width: 100%;z-index: 500;transition: 0.35s;}
        header.white{background-color: #fff;height: 90px;padding: 10px 0 10px 0;}
        .headerContainer{display: flex;max-width: 1640px;margin: 0 auto;justify-content: space-between;align-items: center;padding: 10px 0 10px 0;}
        header .tit_h1{height: 100%;width: 70px;}
        header .tit_h1 a {
            background: url('img/logo.png') no-repeat 0 0;
            height: 55px;
            width: 110px;
            display: block;
            background-size: contain;
        }
        .gnb{
            display: flex;
            width: 60%;
            justify-content: center;
            align-items: center;
        }
        .gnb li{
            text-align: center;
            padding-left: 80px;
        }
        .gnb li:first-child{padding: 0;}
        .gnb a{font-size: 24px;font-weight: 600;}
        .snb{display: flex;}
        .snb li{ width: 100%; height: 100%;}
        .snb a{
            background: url('img/login_icon.png') no-repeat 0 0;
            display: block;
            height: 35px;
            width: 35px;
            margin-right: 5px;
            background-size: contain;
        }
        input[id="menuicon"] {display: none;}
        input[id="menuicon"] +label{display: block;position: relative;width: 70px;cursor: pointer;height: 30px;}
        input[id="menuicon"] +label span{position: absolute;width: 100%;background: #62432d;height: 4px;transform: translateY(-50%);transition: 0.2s;border-radius: 20px;}
        input[id="menuicon"] +label span:first-child{top: 0; width: 60%; right: 0;}
        input[id="menuicon"] +label span:nth-child(2){top: 50%; left: 0; transform: translateY(-50%);}
        input[id="menuicon"] +label span:last-child{top: 100%; width: 70%; right: 0;}
        .go_top{
            background: url('img/go_top.png') no-repeat 0 0;
            height: 113px;
            width: 98px;
            display: block;
            position: fixed;
            bottom: 25px;
            right: 40px;
            background-size: contain;
            font-size: 18px;
            color: #fff;
            display: none;
            cursor: pointer;
        }
        .go_top.show {display: block;}
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

        <section id="board" class="center">
            <div class="con_01Wrap">
                <div class="topText">
                    <h1 data-aos="fade-up" data-aos-duration="1000">온라인예약</h1>
                </div>
                <div class="caption" data-aos="fade-up" data-aos-duration="1000" data-aos-delay="200">
                    <p>예약 문의<br><span>빠른 시일 내에 답변</span>드릴 수 있도록 하겠습니다.</p>
                </div>
            </div>

            <!-- POST 메소드로 데이터 전송 -->
            <form method="post" action="">
                <table class="InquiryBox">
                    <colgroup>
                        <col class="thw">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>문의분류</th>
                            <td class="contactInquiry">
                                <select id="contact" name="inquiry_type">
                                    <option value="예약">예약</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th>성함</th>
                            <td class="flex">
                                <input type="text" name="name" required>
                            </td>
                            <th>휴대폰번호</th>
                            <td class="flex">
                                <select id="contact" name="phone_code">
                                    <option value="010">010</option>
                                </select>
                                <input type="text" name="phoneNum" required>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <div class="sumbit_wrap">
                    <button type="submit">예약하기</button>
                </div>
            </form>
        </section>

        <script>
            $(window).scroll(function() {
                if ($(this).scrollTop() > 0) {
                    $('.go_top').fadeIn().addClass('show'),
                    $('header').fadeIn().addClass('white');
                } else {
                    $('.go_top').fadeOut().removeClass('show'),
                    $('header').removeClass('white');
                }
            });
    
            $('.go_top').click(function() {
                $('html, body').stop().animate({ scrollTop: 0 }, 500);
            });
        </script>
    </body>
</html>
