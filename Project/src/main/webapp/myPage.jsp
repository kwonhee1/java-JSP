<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="service.TokenService" %>
    <%@ page import="model.User" %>
    <% String projectContextPath = request.getContextPath(); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Page</title>
<style>
	body {
		background-color: ;
		position: fixed;
		display: flex;
		justify-content: center;
        align-items: center;
	}

	.profile-container {
		background-color: rgba(255, 255, 255, 0.9);
        border-radius: 10px;
        padding: 30px;
        width: 350px;
        height: 400px;
        box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.2);
        text-align: center;
	}
	
	.profile-photo {
		cursor: pointer;
		width: 100px;
		height: 100px;
	}
	
	.profile-name {
		margin-top: 10px;
	}
	
	.profile-name h1 {
		font-family: 'Arial',sans-serif;
		font-size: 50px;
        margin-bottom: 20px;
        color: #000;
	}
	
	.status-Message {
		font-size: 25px;
		color:#444;
		margin-top: 10px;
		
	}
	
	.edit-profile {
		width: 97%;
        padding: 5px;
        background-color: #000;
        color: #fff;
        border-radius: 5px;
        align-items: center;
        font-size: 15px;
        cursor: pointer;
        margin-top: 10px;
	}
</style>

</head>
<body>
	<div class="profile-container">
		<div class="profile-photo">
			<img src = <%=projectContextPath + "/images/" + user.getImgURI() %>" alt="my page" id="myPage">
		</div>
		<div class = "profile-name">
			<h1><%= user.getName() %>님</h1>
		</div>
		<div class = "status-message">
			<%
				String statusMessage = request.getParameter("statusMessage");
				out.println(statusMessage.replace("<", "&lt;").replace(">", "&gt;").replace("\r\n", "<br/>")+"<br/>");
			%>
		</div>
		<div class = "edit-profile" onclick="window.location.href='/editProfile.jsp';">
			프로필 수정
		</div>
	</div>
</body>
</html>
