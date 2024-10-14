<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.Cookie" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!doctype html>
<html lang="ko">
    <head>
        <title>펫토피아</title>
        <meta charset="utf-8">
        <meta name="description" content="강아지 유치원">
        <meta name="keywords" content="강아지유치원,강아지호텔">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,500;0,600;0,700;1,300;1,400;1,500;1,600;1,700&display=swap" rel="stylesheet">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <!--폰트어썸-->
        <script src="https://kit.fontawesome.com/38a1e1c008.js" crossorigin="anonymous"></script>

        <!-- CSS 스타일 정의 -->
        <style>
            *{margin: 0 ; padding: 0 ; box-sizing: border-box; font-family: "NanumSquare", sans-serif;}
            ul,ol,li{list-style: none;vertical-align: middle;}
            a{text-decoration: none;color: #62432d;}
            body{
                overflow-x: hidden;
                font-family: 'Noto Sans KR', sans-serif;
                font-size: 14px;
                color: #333;
                letter-spacing: -1px;
                background-color: #fff9ed;
                overflow-y: auto; /* 스크롤 문제 해결 */
            }
            ::-webkit-scrollbar {display: none; }
            .blind{left: -9999px; font-size: 0; position: absolute;}
            .center{max-width: 1823px; margin: 0 auto;}

            /* 로그인/회원가입 버튼 스타일 */
            .login-btn, .signup-btn {
                display: inline-block;
                padding: 12px 25px;
                border-radius: 25px;
                background-color: #ff9b00;
                color: white;
                font-size: 16px;
                font-weight: bold;
                margin-right: 10px;
                transition: background-color 0.3s ease;
                border: none;
                cursor: pointer;
            }

            .login-btn:hover, .signup-btn:hover {
                background-color: #ff7700;
            }

            /*메인 페이지*/
            .main_bg{background: url(img/main_bg.png) no-repeat 0 0;height: 900px;width: 100%;background-size: contain;position: relative;}
            .catchphrase {
                position: relative;
                top: 22%;
                max-width: 1660px;
                margin: 0 auto;
                text-align: left;
                opacity: 0;
                animation: slideIn 1s forwards 0.5s;
                font-family: "SCDream";
            }
            @keyframes slideIn {
                0% {transform: translateY(50px); opacity: 0;}
                100% {transform: translateY(0); opacity: 1;}
            }
            .catchphrase h1{font-size: 65px;color: #3f2323;line-height: 85px;padding-bottom: 20px;}
            .catchphrase strong{font-size: 28px;color: #3f2323;}
            .catchphrase .button{height: 50px;width: 200px;border-radius: 50px;color: #fff;background-color: #ff9b00;margin-top: 30px;vertical-align: middle;align-items: center;display: flex;text-align: center;}
            .catchphrase .button a{font-size: 20px;text-align: center;color: #fff;display: block;width: 100%;font-weight: 500;}
            .catchphrase p{font-size: 18px;padding-top: 10px;line-height: 30px;}
            .catchphrase .textBox{max-width: 600px;padding-top: 90px;}
            .catchphrase .textBox span{font-size: 21px;font-weight: 600;padding-left: 20px;}
            .dog_img img{position: absolute;height: 900px;left: 45%;top: 110px;transform: rotate(350deg);}

            /* 헤더 */
            header{position: fixed;width: 100%;z-index: 500;transition: 0.35s;}
            header.white{background-color: #fff;height: 90px;padding: 10px 0 10px 0;}
            .headerContainer{display: flex;max-width: 1640px;margin: 0 auto;justify-content: space-between;align-items: center;padding: 10px 0 10px 0;}
            header .tit_h1{height: 100%;width: 70px;}
            header .tit_h1 a ,.footer-logo{background: url(img/logo.png) no-repeat 0 0;height: 55px;width: 110px;display: block;background-size: contain;}
            .gnb{
                display: flex;
                width: 60%;
                justify-content: center;
                align-items: center;
                font-family: 'Cormorant Garamond';
            }
            .gnb li{
                text-align: center;
                padding-left: 80px;
            }
            .gnb li:first-child{padding: 0;}
            .gnb a{font-size: 24px;font-weight: bold;font-family: "Cormorant Garamond";}
            .snb{display: flex;}
            .snb li{ width: 100%; height: 100%;}
            .snb a{background: url(img/login_icon.png) no-repeat 0 0;display: block;height: 35px;width: 35px;margin-right: 5px;background-size: contain;}
            input[id="menuicon"] {display: none;}
            input[id="menuicon"] +label{display: block;position: relative;width: 70px;cursor: pointer;height: 30px;}
            input[id="menuicon"] +label span{position: absolute;width: 100%;background: #62432d;height: 4px;transform: translateY(-50%);transition: 0.2s;border-radius: 20px;}
            input[id="menuicon"] +label span:first-child{top: 0; width: 60%; right: 0;}
            input[id="menuicon"] +label span:nth-child(2){top: 50%; left: 0; transform: translateY(-50%);}
            input[id="menuicon"] +label span:last-child{top: 100%; width: 70%; right: 0;}

            /*섹션 01*/
            #container{background: url(img/light_blue.png) no-repeat 0 0;margin-top: 6%;margin-bottom: 20%;}
            #container h1{font-size: 50px;text-align: center;color: #333;padding-bottom: 60px;}
            .youtube_layout{width: 80%;margin: 0 auto;height: 770px;}
            iframe{width: 100%;height: 100%;}

            .go_top{
                background: url(img/go_top.png) no-repeat 0 0;
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

            /*호버메뉴 섹션*/
            .menu-container {
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                width: 100%;
                margin: 110px 0 110px 0;
            }
            .title-wrap{width: 80%;height: 200px;padding: 0 0 0 100px;margin-bottom: 40px;}
            .title-wrap .title-wrap-top h3{font-size: 70px;letter-spacing: 0.5px;font-family: "Cormorant Garamond";}
            .title-wrap .title-wrap-top p{font-size: 19px;font-weight: 600;color: #b1a58c;padding-top: 22px;}

            .menu-item {
                position: relative;
                width: 80%;
                height: 200px;
                background-color: #fff;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: background-color 0.4s ease;
                overflow: hidden;
                border-top: 1px solid #d8cdbc;
                background: #fff9ed;
            }

            .menu-item a{width: 100%;padding: 0 0 0 100px;vertical-align: middle;}

            .menu-item:hover .menu-image {
                opacity: 1;
                transform: scale(1.1); 
            }

            .menu-text {
                color: #333;
                font-family: "Cormorant Garamond";
                display: flex;
                align-items: baseline;
            }
            .menu-text .menu_title{font-size: 45px;font-weight: bold;}
            .menu-text span{font-size: 26px;font-weight: 500;font-family: "NanumSquare";padding-left: 2rem;}

            /* 숨겨진 배경 이미지 */
            .menu-image {
                position: absolute;
                top: 0px;
                left: 0;
                width: 100%;
                height: 100%;
                object-fit: cover;
                opacity: 0;
                transition: opacity 0.4s ease, transform 0.4s ease;
            }

            /*리뷰섹션*/
            .reviews {
                padding: 100px 20px;
                background-color: #fff9ed;
                position: relative;
                background: #fff1c1;
            }

            .reviews h2 {
                font-size: 40px;
                text-align: center;
                margin-bottom: 60px;
                color: #333;
                font-family: "Cormorant Garamond";
            }

            .review-container {
                display: flex;
                align-items: center;
                max-width: 1200px;
                margin: 0 auto;
                flex-direction: column;
                font-family: "SCDream";
            }

            .review-item {
                width: 50%;
                height: 200px;
                background-color: white;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                border-radius: 10px;
                margin-bottom: 20px;
                opacity: 0;
                transform: translateX(100%);
                transition: all 0.6s ease-out;
                display: flex;
                align-items: center;
                padding: 25px;
            }

            .review-item.left {transform: translateX(-100%);}
            .review-item.right {transform: translateX(100%);}
            .review-item.active {opacity: 1;transform: translateX(0);}

            .review-box {display: flex;align-items: center;}
            .review-img {width: 100px;height: 100px;object-fit: cover;border-radius: 50%;margin-right: 20px;}
            .review-content {display: flex;flex-direction: column;}
            .review-content .quote {font-size: 18px;line-height: 1.5;margin-bottom: 10px;color: #333;}
            .review-content .author {font-size: 16px;font-weight: 500;color: #62432d;margin-bottom: 5px;}
            .rating {display: flex;font-size: 20px;color: #ff9b00;}

            /* 애니메이션 */
            @keyframes slideInLeft {0% {opacity: 0;transform: translateX(-100%);}100% {opacity: 1;transform: translateX(0);}}
            @keyframes slideInRight {0% {opacity: 0;transform: translateX(100%);}100% {opacity: 1;transform: translateX(0);}}

            /* 사진 갤러리 섹션 */
            .gallery {
                max-width: 1440px;
                position: relative;
                overflow: hidden;
                padding: 7% 0;
                margin: 0 auto;
            }

            .gallery h2 {
                font-size: 40px;
                margin-bottom: 60px;
                text-align: center;
                font-family: "Cormorant Garamond";
            }

            .gallery-wrapper {
                display: flex;
                align-items: center;
            }
            .gallery img {width: 320px;height: 260px;object-fit: cover;margin: 0 10px;border-radius: 10px;transition: transform 0.3s;}

            /* 슬라이드 애니메이션 */
            .slide-left {animation: slideLeft 28s linear infinite;display: flex;padding-bottom: 20px;}
            .slide-right {animation: slideRight 28s linear infinite;display: flex;}

            /* 왼쪽에서 오른쪽으로 슬라이드 */
            @keyframes slideLeft {0% {transform: translateX(0);}100% {transform: translateX(-100%);}}
            /* 오른쪽에서 왼쪽으로 슬라이드 */
            @keyframes slideRight {0% {transform: translateX(-100%);}100% {transform: translateX(0);}}

            /* 그라데이션 효과 */
            .gallery::before,.gallery::after {
                content: '';
                position: absolute;
                top: 0;
                bottom: 0;
                width: 200px;
                z-index: 1;
            }
            .gallery::before {left: 0;background: linear-gradient(to right, rgb(255 249 237) 0%, rgba(255, 255, 255, 0) 100%);}
            .gallery::after {right: 0;background: linear-gradient(to left, rgb(255 249 237) 0%, rgba(255, 255, 255, 0) 100%);}

            /*푸터*/
            footer {
                background-color: #62432d;
                padding: 50px 0;
                color: white;
                display: flex;
                justify-content: center;
            }

            .footer-container {max-width: 1440px;width: 100%;display: flex;flex-direction: column;align-items: center;}
            .footer-menu {display: flex;justify-content: space-between;width: 100%;}
            .footer-container .menuBox{padding-left: 20px;display: flex;width: 80%;}

            .footer-logo {font-size: 28px;margin-bottom: 20px;font-weight: bold;color: #ff9b00;width: 10%;}

            .menu-column {display: flex;flex-direction: column;align-items: flex-start;width: 20%;}

            .menu-column h4 {font-size: 18px;margin-bottom: 10px;}
            .menu-column ul {list-style: none;}
            .menu-column ul li {margin-bottom: 8px;}
            .menu-column ul li a {color: #adadad;text-decoration: none;font-size: 15px;transition: color 0.3s;}
            .menu-column ul li a:hover {color: #ff9b00;}

            .footer-contact {display: flex;align-items: center;width: 100%;padding-bottom: 10px;}

            /* 1:1 채팅 문의 버튼 */
            .chat-button {
                background-color: #ff9b00;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 5px;
                cursor: pointer;
                font-size: 18px;
                transition: background-color 0.3s;
            }

            .chat-button:hover {background-color: #ff7700;}

            /* 채팅 박스 */
            .chat-box {
                display: none;
                background-color: #fff;
                border-radius: 10px;
                box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
                width: 300px;
                position: fixed;
                bottom: 100px;
                right: 30px;
                z-index: 1000;
                overflow: hidden;
                animation: slideUp 0.4s ease-in-out;
                height: 380px;
            }

            @keyframes slideUp {0% {opacity: 0;transform: translateY(20px);}100% {opacity: 1;transform: translateY(0);}}

            .chat-header {
                background-color: #62432d;
                padding: 15px;
                color: white;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .chat-content {
                padding: 15px;
                width: 100%;
            }
            .chat-con{width: 10%;}
            .chat-con p{font-size: 15px;}

            .chat-input {
                padding: 10px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                background-color: #f5f5f5;
                bottom: 0;
                position: absolute;
                width: 100%;
            }

            .chat-input textarea {
                width: 80%;
                border: none;
                border-radius: 5px;
                padding: 10px;
                font-size: 14px;
                resize: none;
                outline: 0;
            }

            .send-button {
                background-color: #ff9b00;
                color: white;
                border: none;
                padding: 10px;
                border-radius: 5px;
                cursor: pointer;
                font-size: 16px;
            }

            .send-button:hover {background-color: #ff7700;}

            .close-chat {font-size: 24px;cursor: pointer;}

            /* 푸터 하단 */
            .footer-bottom {margin-top: 30px;text-align: center;font-size: 14px;width: 100%;border-top: 0.1px solid #ffffff;}
            .footer-bottom p{text-align: left;color: #adadad;}
            .footer-bottom p:nth-child(2){padding-top: 10px;}
            .footer-bottom .social_icon{float: right;padding-top: 10px;}
            .footer-bottom .social_icon a{width: 100%;}
            .footer-bottom .social_icon a img{height: 30px; width: 30px;}
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
                    <li><a href="javascript:void(0)" onclick="checkLogin();">HOTEL</a></li>
                    <li><a href="#none">DOG TRAINING</a></li>
                    <li><a href="#none">SPA & BEAUTY</a></li>
                    <li><a href="./reservation.jsp">CONTACT</a></li>
                </ul>

                <div class="snb">
                    <%-- 로그인한 사용자 정보를 버튼으로 표시 --%>
                    <% 
                        // 세션에서 "loginid"라는 이름으로 저장된 값을 가져옴.
                        // 만약 로그인한 사용자가 있다면, 해당 사용자의 아이디가 "loginid" 변수에 저장됨.
                        String loginid = (String) session.getAttribute("loginid");
                    %>

                    <% if (loginid != null) { %>
                        <!-- 로그인한 사용자의 아이디를 버튼 형태로 보여줌 -->
                        <button class="login-btn"> 사용자: <%= loginid %> </button>
                        
                        <%-- 만약 로그인한 사용자가 "admin" (관리자)라면, 예약자 정보 조회 버튼을 추가로 표시 --%>
                        <% if (loginid.equals("admin")) { %>
                            <button class="signup-btn" onclick="location.href='./reservation_info.jsp'"> 예약자 정보 조회 </button>
                        <% } %>
                        
                        <!-- 로그아웃 버튼을 표시해, 클릭 시 로그아웃 처리를 함 -->
                        <button class="signup-btn" onclick="location.href='./logout.jsp'"> 로그아웃 </button>
                    <% } else { %>
                        <!-- 로그인하지 않은 경우에는 로그인 버튼을 보여줌, 클릭 시 로그인 페이지로 이동 -->
                        <button class="login-btn" onclick="location.href='./login.jsp'"> 로그인 </button>
                        
                        <!-- 회원가입 버튼을 보여주며, 클릭 시 회원가입 페이지로 이동 -->
                        <button class="signup-btn" onclick="location.href='./signup.jsp'"> 회원가입 </button>
                    <% } %>
                </div>

                <input type="checkbox" id="menuicon" name="menuicon">
                <label for="menuicon">
                    <span></span>
                    <span></span>
                    <span></span>
                </label>
            </div>
        </header>

        <div class="main">
            <div class="main_bg">
                <div class="catchphrase">
                    <h1>댕댕이 행복 1위, <br>보호자 만족도 1위!</h1>
                    <div class="textBox">
                        <strong>모두가 다시 찾는 곳! <span>펫토피아 강아지 유치원</span></strong>
                        <p>강아지를 먼저 생각하고, 강아지만을 위한 넓은 공간 및 산책 등의 DAY CARE! 
                            반려견과 견주들의 행복한 생활을 위해 영국 데이케어 방식의 펫토피아!
                        </p>
                    </div>
                    <div class="button">
                        <a href="#none">자세히 보기</a>
                    </div>
                </div>

                <div class="dog_img">
                    <img src="img/dog_03.png">
                </div>
            </div>
        </div>

        <!-- 서비스 소개 섹션 -->
        <div class="menu-container">
            <div class="title-wrap">
                <div class="title-wrap-top">
                    <h3>Pettopia <span>Services</span></h3>
                    <p>사랑하는 반려견을 위한 프리미엄 케어, 펫토피아와 함께하세요.</p>
                </div>
            </div>

            <!-- Daycare 메뉴 -->
            <div class="menu-item">
                <a href="#none">
                    <div class="menu-text">
                        <p class="menu_title">Day Care</p>
                        <span>데이케어</span>
                    </div>
                    <img src="img/dog-bed2.jpg" alt="데이케어 이미지" class="menu-image"/>
                </a>
            </div>

            <!-- Hotel 메뉴 -->
            <div class="menu-item">
                <a href="#none">
                    <div class="menu-text">
                        <p class="menu_title">Hotel</p>
                        <span>호텔</span>
                    </div>
                    <img src="img/hotel.jpg" alt="호텔 이미지" class="menu-image"/>
                </a>
            </div>

            <!-- Training 메뉴 -->
            <div class="menu-item">
                <a href="#none">
                    <div class="menu-text">
                        <p class="menu_title">Training</p>
                        <span>트레이닝</span>
                    </div>
                    <img src="img/dog_gallery06.jpg" alt="훈련 이미지" class="menu-image"/>
                </a>
            </div>

            <!-- Spa & Beauty 메뉴 -->
            <div class="menu-item">
                <a href="#none">
                    <div class="menu-text">
                        <p class="menu_title">Spa & Beauty</p>
                        <span>스파 앤 뷰티</span>
                    </div>
                    <img src="img/dog-spa.jpg" alt="스파 이미지" class="menu-image"/>
                </a>
            </div>
        </div>

        <!-- 고객 후기 섹션 -->
        <section class="reviews">
            <h2>Review</h2>
            <div class="review-container">
                <div class="review-item left">
                    <div class="review-box">
                        <div class="imgContainer">
                            <img src="img/reveiw_profile01.jpg" alt="고객 사진" class="review-img">
                        </div>
                        <div class="review-content">
                            <p class="quote">"우리 마루가 이곳을 너무 좋아해요! 항상 즐겁게 뛰어놀고 돌아옵니다."</p>
                            <p class="author">- 마루, 서울</p>
                            <div class="rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star-half-alt"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="review-item right">
                    <div class="review-box">
                        <div class="imgContainer">
                            <img src="img/reveiw_profile02.jpg" alt="고객 사진" class="review-img">
                        </div>
                        <div class="review-content">
                            <p class="quote">"시설이 깨끗하고 직원분들이 정말 친절해요. 저희 강아지를 안심하고 맡길 수 있어요."</p>
                            <p class="author">- 꾸미, 인천</p>
                            <div class="rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="review-item left">
                    <div class="review-box">
                        <div class="imgContainer">
                            <img src="img/reveiw_profile03.jpg" alt="고객 사진" class="review-img">
                        </div>
                        <div class="review-content">
                            <p class="quote">"정말로 신뢰할 수 있는 데이케어입니다. 우리 강아지가 행복해하는 모습을 보니 저도 기분이 좋아요."</p>
                            <p class="author">- 구찌, 남양주</p>
                            <div class="rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- 사진 갤러리 섹션 -->
        <section class="gallery">
            <h2>Gallery</h2>
            <ul class="imgBox slide-left">
                <li><img src="img/dog_gallery01.jpg" alt="Gallery Image 1"></li>
                <li><img src="img/dog_gallery02.jpg" alt="Gallery Image 2"></li>
                <li><img src="img/dog_gallery03.png" alt="Gallery Image 3"></li>
                <li><img src="img/dog_gallery04.jpg" alt="Gallery Image 4"></li>
                <li><img src="img/dog_gallery05.jpg" alt="Gallery Image 5"></li>
                <li><img src="img/dog_gallery06.jpg" alt="Gallery Image 6"></li>
                <li><img src="img/dog_gallery07.jpg" alt="Gallery Image 7"></li>
                <li><img src="img/dog_gallery08.jpg" alt="Gallery Image 8"></li>
            </ul>

            <ul class="imgBox slide-right">
                <li><img src="img/dog_gallery09.jpg" alt="Gallery Image 9"></li>
                <li><img src="img/dog_gallery10.jpg" alt="Gallery Image 10"></li>
                <li><img src="img/dog_gallery11.jpg" alt="Gallery Image 11"></li>
                <li><img src="img/dog_gallery12.jpg" alt="Gallery Image 12"></li>
                <li><img src="img/dog_gallery13.jpg" alt="Gallery Image 13"></li>
                <li><img src="img/dog_gallery14.jpg" alt="Gallery Image 14"></li>
                <li><img src="img/dog_gallery15.jpg" alt="Gallery Image 15"></li>
                <li><img src="img/dog_gallery16.jpg" alt="Gallery Image 16"></li>
                <li><img src="img/dog_gallery17.jpg" alt="Gallery Image 17"></li>
            </ul>
        </section>

        <!-- 유튜브 -->
        <section id="container">
            <h1>펫토피아에서 노는 우리 강아지 모습!</h1>
            <div class="youtube_layout">
                <iframe width="560" height="315" src="https://www.youtube.com/embed/vJEzhJW2n40?si=Lr8rwLKWDwUinb83&amp;controls=0" title="YouTube video player" 
                frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
                referrerpolicy="strict-origin-when-cross-origin" allowfullscreen>
                </iframe>
            </div>
        </section>

        <footer>
            <div class="footer-container">
                <!-- 푸터 메뉴 -->
                <div class="footer-menu">
                    <div class="footer-logo"></div>
                    <div class="menuBox">
                        <div class="menu-column">
                            <h4>Service</h4>
                            <ul>
                                <li><a href="#none">DAYCARE</a></li>
                                <li><a href="#none">호텔</a></li>
                                <li><a href="#none">훈련</a></li>
                                <li><a href="#none">스파 & 뷰티</a></li>
                            </ul>
                        </div>
                        <div class="menu-column">
                            <h4>고객 지원</h4>
                            <ul>
                                <li><a href="#none">FAQ</a></li>
                                <li><a href="#none">이용 약관</a></li>
                                <li><a href="#none">개인정보 보호 정책</a></li>
                                <li><a href="#none">연락처</a></li>
                            </ul>
                        </div>
                        <div class="menu-column">
                            <h4>커뮤니티</h4>
                            <ul>
                                <li><a href="#none">블로그</a></li>
                                <li><a href="#none">이벤트</a></li>
                                <li><a href="#none">리뷰</a></li>
                            </ul>
                        </div>
                    </div>

                    <div class="chat-con">
                        <!-- 1:1 채팅 문의 버튼 -->
                        <div class="footer-contact">
                            <button class="chat-button" id="chatToggle">1:1 채팅 문의</button>
                        </div>
                        <p>운영시간: 09:30 ~ 18:00 <br>(주말/공휴일 휴무)</p>
                    </div>
                </div>

                <!-- 토글 가능한 채팅 창 -->
                <div id="chatBox" class="chat-box">
                    <div class="chat-header">
                        <h4>펫토피아 1:1 문의</h4>
                        <span id="closeChat" class="close-chat">&times;</span>
                    </div>
                    <div class="chat-content">
                        <p>채팅으로 문의하세요. 담당자가 신속히 답변드립니다.</p>
                    </div>
                    <div class="chat-input">
                        <textarea placeholder="메시지를 입력하세요..." rows="3"></textarea>
                        <button class="send-button">전송</button>
                    </div>
                </div>

                <!-- 하단 -->
                <div class="footer-bottom flex">
                    <div class="social_icon">
                        <a href="#none"><img src="img/instar_icon.png"></a>
                        <a href="#none"><img src="img/kakaotalk_icon.png"></a>
                    </div>
                    <p>상호명 : 개린이꾸미구찌 | 대표 : 임희진,남진영 | dorudgmlwls@naver.com</p>
                    <p>사업자 번호 : 127-00-83655 | 통신판매업 신고번호 : 2022-서울한남-1227</p>
                    <p>© 2024 개린이꾸미구찌 All rights reserved.</p>
                </div>
            </div>
        </footer>

        <div class="go_top"></div>

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

            // 채팅 버튼 토글
            const chatToggle = document.getElementById('chatToggle');
            const chatBox = document.getElementById('chatBox');
            const closeChat = document.getElementById('closeChat');

            chatToggle.addEventListener('click', function() {
                chatBox.style.display = 'block';
            });

            closeChat.addEventListener('click', function() {
                chatBox.style.display = 'none';
            });

            // 리뷰 애니메이션 활성화
            const reviews = document.querySelectorAll('.review-item');
            let observer = new IntersectionObserver(function(entries) {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('active');
                    }
                });
            }, { threshold: 0.3 });

            reviews.forEach(review => {
                observer.observe(review);
            });

                // 로그인 상태 확인
                function checkLogin() {
                    // 자바스크립트에서 JSP 변수를 사용할 때는 문자열로 처리해야 하므로 작은 따옴표('')를 사용.
                    // loginid 값이 null이 아니면 'loggedIn', null이면 'notLoggedIn'이라는 값을 자바스크립트 변수로 전달.
                    var loginStatus = '<%= (loginid != null) ? "loggedIn" : "notLoggedIn" %>';
                    
                    // 만약 사용자가 로그인되어 있으면 (즉, loginStatus가 'loggedIn'이면)
                    // 호텔 예약 페이지(order.jsp)로 이동함.
                    if (loginStatus === 'loggedIn') {
                        window.location.href = './order.jsp';
                    } else {
                        // 로그인이 되어 있지 않으면 알림 창을 띄우고, 로그인이 필요하다는 메시지를 출력함.
                        alert('회원 전용 페이지입니다. 로그인이 필요합니다.');
                    }
                }
        </script>
    </body>
</html>
