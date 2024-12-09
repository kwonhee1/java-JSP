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
            position: fixed; 
            top: 0;
            left: 0;
            width: 100%; 
            padding: 0px; 
            display: flex; 
            justify-content: flex-end; 
            align-items: center; 
            z-index: 1000; 
            background: rgb(0, 0, 0, 0.1);
        }

        header div, header .username {
            color: white; 
            margin-left: 20px; 
            text-decoration: none; 
            font-size: 16px;
            cursor: pointer; 
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
    		padding: 60px;    
    		background-color: rgba(0, 0, 0, 0.3)
		}
        
        .side {
            position: fixed;
            top: 60px; 
            right: -30%; 
            width: 25%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.8);
            z-index: 100;
            transition: left 0.3s ease; 
        }
        .side.open {
            right: 0; 
        }

        .side-content {
            color: white;
            padding: 15px;
        }
        
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
            var sideMenu = document.querySelector('#side1');
            sideMenu.classList.toggle('open'); 
        }
    	
        function toggleSideMenu2() {
            var sideMenu = document.querySelector('#side2');
            sideMenu.classList.toggle('open'); 
        }

        // 로그아웃 쿠키 삭제 함수
        function eraseCookie() {
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
    		<% if(user.isAdmin()) {%>
    		  <a href="admin.jsp">admin page</a>
    		<% } %>
    		<a><%= user.getName() %>님</a>
            <img src="<%=projectContextPath + "/images/" + user.getImgURI() %>" alt="my page" onclick="toggleSideMenu()" style="cursor: pointer; width: 30px; height: 30px;" id="myPage">
            <div class="username" onClick=eraseCookie()>로그아웃</div>
        <% } else { %>
            <div onClick="toggleSideMenu()">로그인</div>
            <div onClick="toggleSideMenu2()">회원 가입</div>
        <% } 
        %>
     <br> <br> <br>
	</header>
   
    <div class="main-banner">
    	<div class="main-content">
    		<jsp:include page="/new.jsp" />
    	</div>
    </div>
    
    <div class="side" id="side1">
        <div class="side-content">
        	<%
        		if(user == null){
        			%> <jsp:include page="/login.jsp" /> <%
        		}else{
        			%> <jsp:include page="/user.jsp" /> <%
        		}
        	%>
        </div>
    </div>
    
    <div class="side" id="side2" style="z-index: 101;">
    	<div class="side-content">
        	<jsp:include page="/regist.jsp" />
    	</div>
	</div>


</body>
</html>
