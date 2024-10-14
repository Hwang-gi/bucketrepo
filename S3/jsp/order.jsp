<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!--
216번째 줄: 데이터베이스 연결 정보 (dbURL, dbUser, dbPassword) 설정
229번째 줄: SQL 쿼리 실행 (services 테이블에서 서비스 이름, 설명, 가격, 이미지 URL을 가져옴/롤링업데이트시 services2(테이블)만 변경해주면됩니다)
183번째 줄: 로고 클릭 시 main.jsp로 이동
190번째 줄: HOTEL 클릭 시 order.jsp로 이동
193번째 줄: CONTACT 클릭 시 reservation.jsp로 이동
198번째 줄: 우측 로그인 버튼 클릭 시 login.jsp로 이동
-->


<!doctype html>
<html lang="ko">
<head>
    <title>펫토피아</title>
    <meta charset="utf-8">
    <meta name="description" content="강아지 유치원">
    <meta name="keywords" content="강아지유치원,강아지호텔">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <!--폰트어썸-->
    <script src="https://kit.fontawesome.com/38a1e1c008.js" crossorigin="anonymous"></script>
</head>
<style>
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
        overflow-y: scroll;
    }
    ::-webkit-scrollbar {display: none;}
    .blind{left: -9999px; font-size: 0; position: absolute;}
    .center{max-width: 1823px; margin: 0 auto;}
    .flex{display: flex;}
    .imgBox strong{font-size: 40px;position: absolute;width: 100%;left: 0;top: 26%;color: #545043;line-height: 70px; text-align: center;}
    .containerBox{padding-top: 10%;}
    .container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 20px;
    }
    h1 {
        color: #333;
        margin-bottom: 30px;
        text-align: center;
    }
    .services {
        display: flex;
        justify-content: space-between;
        flex-wrap: wrap;
    }
    .service-item {
        background-color: #fff;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        padding: 20px;
        margin: 10px;
        flex-basis: 30%;
        text-align: left;
    }
    .service-item img {
        width: 100%;
        height: auto;
        border-radius: 10px;
    }
    .service-item h2 {
        font-size: 24px;
        color: #62432d;
    }
    .service-item p {
        color: #666;
        font-size: 16px;
        margin-bottom: 10px;
    }
    .price {
        font-size: 18px;
        color: #333;
        font-weight: bold;
    }
    .button {
        background-color: #62432d;
        color: white;
        padding: 10px 20px;
        text-decoration: none;
        border-radius: 5px;
        font-size: 16px;
        margin-top: 10px;
        display: inline-block;
    }
    .button:hover {
        background-color: #503520;
    }
    header{position: fixed;width: 100%;z-index: 500;transition: 0.35s;}
    header.white{background-color: #fff;height: 90px;padding: 10px 0 10px 0;}
    .headerContainer{display: flex;max-width: 1640px;margin: 0 auto;justify-content: space-between;align-items: center;padding: 10px 0 10px 0;}
    .blind{left: -9999px;font-size: 0;position: absolute;}
    header .tit_h1{height: 100%;width: 70px;}
    header .tit_h1 a {background: url('./img/logo.png') no-repeat 0 0;height: 55px;width: 110px;display: block;background-size: contain;}
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
    .snb a{background: url('./img/login_icon.png') no-repeat 0 0;display: block;height: 35px;width: 35px;margin-right: 5px;background-size: contain;}
    input[id="menuicon"] {display: none;}
    input[id="menuicon"] +label{display: block;position: relative;width: 70px;cursor: pointer;height: 30px;}
    input[id="menuicon"] +label span{position: absolute;width: 100%;background: #62432d;height: 4px;transform: translateY(-50%);transition: 0.2s;border-radius: 20px;}
    input[id="menuicon"] +label span:first-child{top: 0; width: 60%; right: 0;}
    input[id="menuicon"] +label span:nth-child(2){top: 50%; left: 0; transform: translateY(-50%);}
    input[id="menuicon"] +label span:last-child{top: 100%; width: 70%; right: 0;}

    /* 모달 창 스타일 */
    #datePickerModal {
        display: none;
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        width: 400px;
        background-color: #fff;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.2);
        z-index: 1000;
    }
    #datePickerModal h2 {
        text-align: center;
        margin-bottom: 20px;
    }
    #datePickerModal input {
        width: 100%;
        padding: 10px;
        margin-bottom: 20px;
        border: 1px solid #ccc;
        border-radius: 5px;
    }
    #datePickerModal button {
        width: 100%;
        padding: 10px;
        background-color: #62432d;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
    }
    #datePickerModal button:hover {
        background-color: #503520;
    }
    #modalBackdrop {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        z-index: 900;
    }
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
                <li><a href="./order.jsp">HOTEL</a></li>
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
    
    <div class="containerBox">
        <div class="container">
            <h1>펫토피아 호텔 서비스 상품</h1>
            <div class="services">
                <% 
                    // DB 연결 설정
                    String dbURL = "jdbc:mariadb://10.240.2.201/yas";
                    String dbUser = "root"; 
                    String dbPassword = "password";
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;

                    try {
                        // DB 연결
                        Class.forName("org.mariadb.jdbc.Driver");
                        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                        // SQL 쿼리 실행 (서비스 정보 및 가격 가져오기) (FROM=테이블 name 롤링업데이트시 참고)
                        String sql = "SELECT service_name, description, price, image_url FROM services"; 
                        pstmt = conn.prepareStatement(sql);
                        rs = pstmt.executeQuery();

                        // 각 서비스 상품을 반복문으로 출력
                        while (rs.next()) {
                            String serviceName = rs.getString("service_name");
                            String description = rs.getString("description");
                            double price = rs.getDouble("price");
                            String imageUrl = rs.getString("image_url");
                %>
                <!-- HTML로 서비스 출력 -->
                <div class="service-item">
                    <img src="<%= imageUrl %>" alt="<%= serviceName %>">
                    <h2><%= serviceName %></h2>
                    <p><%= description %></p>
                    <p class="price">₩<%= String.format("%,.0f", price) %></p>
                    <button class="button" onclick="openDatePicker()">예약하기</button>
                </div>
                <% 
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (rs != null) try { rs.close(); } catch (Exception e) { e.printStackTrace(); }
                        if (pstmt != null) try { pstmt.close(); } catch (Exception e) { e.printStackTrace(); }
                        if (conn != null) try { conn.close(); } catch (Exception e) { e.printStackTrace(); }
                    }
                %>
            </div>
        </div>
    </div>

    <div class="go_top"></div>

    <!-- 모달 창 (날짜 선택) -->
    <div id="datePickerModal">
        <div class="datePickerWrapper">
            <h2>예약 날짜 선택</h2>
            <input type="text" id="datepicker" readonly>
            <button id="confirmBooking" onclick="confirmBooking()">결제하기</button>
        </div>
    </div>
    <!-- 모달 백그라운드 -->
    <div id="modalBackdrop"></div>

    <script>
        // 스크롤에 따른 헤더 효과
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

        // 예약 날짜 선택 기능
        function openDatePicker() {
            $("#datePickerModal").show();
            $("#modalBackdrop").show();  // 백그라운드 표시
            $("#datepicker").datepicker({
                minDate: 0,
                maxDate: "+1M"
            });
        }

        function confirmBooking() {
            const selectedDate = $("#datepicker").val();
            if (selectedDate) {
                alert("예약이 완료되었습니다! 예약 날짜: " + selectedDate);
                $("#datePickerModal").hide();
                $("#modalBackdrop").hide();  // 백그라운드 숨김
            } else {
                alert("예약 날짜를 선택해주세요.");
            }
        }

        // 모달창 바깥 클릭 시 닫기
        $("#modalBackdrop").click(function() {
            $("#datePickerModal").hide();
            $("#modalBackdrop").hide();
        });
    </script>
</body>
</html>
