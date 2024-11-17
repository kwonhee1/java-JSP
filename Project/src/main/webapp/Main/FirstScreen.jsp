<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
	<%@ page import="service.TokenService" %>
	<%@ page import="model.User" %>
	<% String projectContextPath = request.getContextPath(); %>
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
            font-family: 'Black Han Sans', serif;
            background-color: #f8f8f8;
        }

        header {
            background-color: #000;
            padding: 20px;
            display: flex;
            justify-content: flex-end;
            align-items: center;
        }

        header a {
            color: white;
            margin-left: 20px;
            text-decoration: none;
            font-size: 16px;
        }

        .main-banner {
            position: relative;
            width: 100%;
            height: 100vh;
            background-image : url("<%=projectContextPath%>/Main/img/1-11.jpg");
        }

        .main-banner h1 {
            position: absolute;
            top: 20%;
            left: 50%;
            transform: translateX(-50%);
            color: white;
            font-size: 36px;
            text-align: center;
        }

        .main-banner .search-box {
            position: absolute;
            top: 35%;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
        }

        .search-box input[type="text"] {
            padding: 10px;
            font-size: 16px;
            width: 300px;
            border: none;
            border-radius: 4px;
        }

        .search-box button {
            padding: 10px 20px;
            font-size: 16px;
            border: none;
            background-color: #ff7f50;
            color: white;
            cursor: pointer;
            border-radius: 4px;
        }

        .sections {
            display: flex;
            justify-content: space-around;
            padding: 50px 20px;
            background-color: rgba(0, 0, 0, 0.2);
        }

        .section {
            width: 23%;
            text-align: center;
            color: white;
        }

        .section h2 {
            font-size: 24px;
            margin-bottom: 10px;
        }

        .section p {
	    font-family: 'Noto Serif KR', serif;
            font-size: 16px;
            margin-bottom: 20px;
        }
        header .username {
            color: white;         /* Red color */
            font-weight: bold;  /* Bold text */
            font-size: 18px;    /* Increased font size */
            margin-right: 10px; /* Spacing between name and logout */
            cursor: pointer;
        }
    </style>
</head>
<body>

    <header>
    	<%
		TokenService tokenService = new TokenService();
    	User user = tokenService.check(request, response);
    	if(user != null){
    	%>
            <span class="username"><%= user.getName() %>님</span>
            <div class="username" onClick=eraseCookie()>로그아웃</div>
        <% } else { %>
            <a href="LoginPage">로그인</a>
            <a href="RegistPage">회원가입</a>
        <% } 
        %>
    </header>
    
    <script>
    	function eraseCookie(){
    		console.log("clicked")
    		document.cookie = "token=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
    		window.location.reload("true")
    	}
    </script>

    <div class="main-banner">
        <h1>오늘 당신이 운동할 곳은 어디인가요?</h1>

        <div class="search-box">
            <input type="text" placeholder="Search...">
            <button>검색</button>
        </div>

        <div class="sections">
            <div class="section" onclick="location.href='링크 URL';">
                <h2>오늘 당신의 운동 루틴</h2>
                <p>당신이 자극시키고 싶은 근육부터 하루 / 7일 동안 할 루틴까지!</p>
            </div>
            <div class="section" onclick="location.href='<%=projectContextPath+"/Map" %>';">
                <h2>당신 주변의 헬스장들은?</h2>
                <p>당장 운동하고 싶은데... 주변에 좋은 헬스장 없나?</p>
            </div>
            <div class="section" onclick="location.href='';">
                <h2>당신이 원하는 운동 후 식단</h2>
                <p>누군가 말했다... "운동 후 먹는 것까지 운동이다."</p>
            </div>
            <div class="section" onclick="location.href='<%=projectContextPath+"/Board" %>';">
                <h2>실시간 오운완 커뮤니티</h2>
                <p>혼자 운동하는 건 좀 지루한데... 사람들과의 즐거운 운동 라이프!</p>
            </div>
        </div>
    </div>

</body>
</html>
