<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="service.TokenService" %>
	<%@ page import="model.User" %>
	<% String projectContextPath = request.getContextPath();%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FYGE - 당신의 최적의 운동</title>
    <style>
    	body, html {
            margin: 0;
            padding: 0;
            font-family: 'Arial', sans-serif;
            background-color: #f8f8f8;
        }
        
    	header {
            position: fixed; /* 화면에 고정 */
            top: 0; /* 페이지 최상단에 위치 */
            left: 0;
            width: 100%; /* 페이지 전체 폭 */\
            padding: 0px; /* 패딩 추가 */
            display: flex; /* 가로 정렬 */
            justify-content: flex-end; /* 오른쪽 정렬 */
            align-items: center; /* 세로 가운데 정렬 */
            z-index: 1000; /* 다른 요소 위에 배치 */
        }

        header a, header .username {
            color: white; /* 텍스트 색상 */
            margin-left: 20px; /* 요소 간 간격 */
            text-decoration: none; /* 밑줄 제거 */
            font-size: 16px; /* 글자 크기 */
            cursor: pointer; /* 포인터 커서 */
        }

        .main-banner {
            background-image: url("<%=projectContextPath%>/Main/img/1-11.jpg");
            background-size: cover;
            background-position: center;
            margin-top: 0px; /* 헤더 아래로 띄우기 */
            justify-content: center;
            align-items: center;
        }
        
        .main-content {
    		padding: 60px;    /* 위쪽 여백 120px */\
    		background-color: rgba(0, 0, 0, 0.3)
		}
        
        .side {
            position: fixed;
            top: 60px; /* 헤더 아래 위치 */
            right: -30%; /* 시작 시 화면 밖으로 숨김 */
            width: 30%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.8);
            z-index: 999;
            transition: left 0.3s ease; /* 애니메이션 효과 */
        }
        .side.open {
            right: 0; /* 클릭 시 왼쪽으로 30% 영역을 차지 */
        }

        /* 사이드 안의 콘텐츠 */
        .side-content {
            color: white;
            padding: 20px;
        }

        /* 메인 배너와 사이드 영역을 겹치게 하기 */
        .main-banner {
            position: relative;
            z-index: 1;
        }

    </style>
    <script>
    	function eraseCookie(){
    		console.log("clicked")
    		document.cookie = "token=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
    		window.location.reload("true")
    	}
    	// 사이드 메뉴 열고 닫기 함수
        function toggleSideMenu() {
            var sideMenu = document.querySelector('.side');
            sideMenu.classList.toggle('open'); // 'open' 클래스를 토글하여 왼쪽으로 열리거나 닫히게 함
        }

        // 로그아웃 쿠키 삭제 함수
        function eraseCookie() {
            console.log("clicked");
            document.cookie = "token=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
            window.location.reload("true");
        }
    </script>
</head>
<body>
    <header>
    	<%
    	TokenService tokenService = new TokenService();
    	    	User user = tokenService.getUserFromToken(request, response);
    	    	if(user != null){
    	%>
    		<a><%= user.getName() %>님</a>
            <img src="<%=projectContextPath + "/images/" + user.getImgURI() %>" alt="my page" onclick="toggleSideMenu()" style="cursor: pointer; width: 30px; height: 30px;" id="myPage">
            <div class="username" onClick=eraseCookie()>로그아웃</div>
        <% } else { %>
            <a href="login.jsp">로그인</a>
            <a href="regist.jsp">회원가입</a>
        <% } 
        %>
     <br> <br> <br>
	</header>
   
    <div class="main-banner">
    	<div class="main-content">
    		<jsp:include page="/new.jsp" />
    	</div>
    </div>
    
    <div class="side">
        <div class="side-content">
            <h2>사이드 메뉴</h2>
            <p>여기에는 추가적인 메뉴나 콘텐츠가 들어갑니다.</p>
        </div>
    </div>

</body>
</html>
