<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="model.User" %>
<%@ page import="model.Gym" %>
<%@ page import="model.Board" %>
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
    <form action="<%= path %>/admin/dashboard" method="post">
        <ul>
            <% for (User user : userList) { %>
                <li>
                    <%= user.getName() %> - <%= user.getEmail() %> 
                    <button type="submit" name="action" value="deleteUser">삭제</button>
                    <button type="submit" name="action" value="updateUser">수정</button>
                    <input type="hidden" name="userId" value="<%= user.getId() %>">
                    <input type="text" name="name" value="<%= user.getName() %>">
                    <input type="text" name="email" value="<%= user.getEmail() %>">
                </li>
            <% } %>
        </ul>
    </form>
<% } else { %>
    <p>등록된 사용자가 없습니다.</p>
<% } %>

<h2>헬스장 검색</h2>
<form action="<%= path %>/admin/dashboard" method="post">
    <input type="text" name="gymName" placeholder="헬스장 이름 검색">
    <button type="submit" name="action" value="searchGym">검색</button>
</form>

<h2>헬스장 목록</h2>
<% if (gymList != null && !gymList.isEmpty()) { %>
    <form action="<%= path %>/admin/dashboard" method="post">
        <ul>
            <% for (Gym gym : gymList) { %>
                <li>
                    <%= gym.getName() %> - 위치 (X: <%= gym.getX() %>, Y: <%= gym.getY() %>) 
                    <button type="submit" name="action" value="updateGym">상태 업데이트</button>
                    <input type="hidden" name="gymId" value="<%= gym.getId() %>">
                    <input type="checkbox" name="status" value="true"> 영업
                    <input type="checkbox" name="status" value="false"> 영업 안함
                </li>
            <% } %>
        </ul>
    </form>
<% } else { %>
    <p>등록된 헬스장이 없습니다.</p>
<% } %>

<h2>게시판 목록</h2>
<% if (boardList != null && !boardList.isEmpty()) { %>
    <form action="<%= path %>/admin/dashboard" method="post">
        <ul>
            <% for (Board board : boardList) { %>
                <li>
                    <%= board.getTitle() %> - <%= board.getContent() %>
                    <button type="submit" name="action" value="updateBoard">수정</button>
                    <input type="hidden" name="boardId" value="<%= board.getId() %>">
                    <input type="text" name="title" value="<%= board.getTitle() %>">
                    <textarea name="content"><%= board.getContent() %></textarea>
                </li>
            <% } %>
        </ul>
    </form>
<% } else { %>
    <p>등록된 게시글이 없습니다.</p>
<% } %>

</body>
</html>
