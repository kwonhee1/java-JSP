	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@ page import="model.User, model.Gym, model.Board" %>
	<%@ page import="java.util.List" %>
	
	<% 
	    String path = request.getContextPath(); 
	    List<User> userList = (List<User>) request.getAttribute("userList"); 
	    List<Gym> gymList = (List<Gym>) request.getAttribute("gymList"); 
	    List<Board> boardList = (List<Board>) request.getAttribute("boardList");
	%>
	
	<!DOCTYPE html>
	<html lang="ko">
	<head>
	    <meta charset="UTF-8">
	    <title>관리자 페이지</title>
	</head>
	<body>
	
	<h1>관리자 페이지</h1>
	
	<h2>사용자 목록</h2>
	<% if (userList != null && !userList.isEmpty()) { %>
	    <ul>
	        <% for (User user : userList) { %>
	            <li><%= user.getName() %> - <%= user.getEmail() %></li>
	        <% } %>
	    </ul>
	<% } else { %>
	    <p>등록된 사용자가 없습니다.</p>
	<% } %>
	<form action="<%= path %>/admin/addUser" method="post">
    <button type="submit">사용자 추가</button>
    </form>
    <form action="<%= path %>/admin/deleteUser" method="post">
    <button type="submit">사용자 삭제</button>
    </form>
	
	<h2>헬스장 목록</h2>
	<% if (gymList != null && !gymList.isEmpty()) { %>
	    <ul>
	        <% for (Gym gym : gymList) { %>
	            <li><%= gym.name %> - 위치 (X: <%= gym.x %>, Y: <%= gym.y %>)</li>
	        <% } %>
	    </ul>
	<% } else { %>
	    <p>등록된 헬스장이 없습니다.</p>
	<% } %>
	<form action="<%= path %>/admin/addGym" method="post">
    <button type="submit">헬스장 추가</button>
    </form>
    <form action="<%= path %>/admin/deleteGym" method="post">
    <button type="submit">헬스장 삭제</button>
    </form>
	
	
	<h2>게시글 목록</h2>
	<% if (boardList != null && !boardList.isEmpty()) { %>
	    <ul>
	        <% for (Board board : boardList) { %>
	            <li><%= board.getTitle() %> - <%= board.getContent() %></li>
	        <% } %>
	    </ul>
	<% } else { %>
	    <p>게시글이 없습니다.</p>
	<% } %>
	<form action="<%= path %>/admin/addBoard" method="post">
    <button type="submit">게시글 추가</button>
    </form>
    <form action="<%= path %>/admin/deleteBoard" method="post">
    <button type="submit">게시글 삭제</button>
    </form>
	
	</body>
	</html>
