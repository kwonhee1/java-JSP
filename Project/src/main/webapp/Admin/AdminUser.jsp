<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>사용자 관리</title>
</head>
<body>
    <h1>사용자 관리</h1>
    <table border="1">
        <thead>
            <tr>
                <th>사용자 ID</th>
                <th>비밀번호</th>
                <th>이메일</th>
                <th>전화번호</th>
                <th>수정</th>
                <th>삭제</th>
                <th>이미지</th>
            </tr>
        </thead>
        <tbody>
            <%
                // User 리스트를 가져옴 (컨트롤러에서 request에 저장된 userList를 가정)
                List<User> userList = (List<User>) request.getAttribute("userList");

                if (userList != null) {
                    for (User user : userList) {
            %>
                        <tr>
                            <td><%= user.getId() %></td>
                            <td><%= user.getPasswd() %></td>
                            <td><%= user.getEmail() %></td>
                            <td><%= user.getKey() != null ? user.getKey() : "전화번호 없음" %></td> <!-- 전화번호가 없다면 대체 텍스트 출력 -->
                            <td><a href="./AdminUser?userId=<%= user.getId() %>">수정</a></td>
                            <td><a href="./DeleteUser?userId=<%= user.getId() %>">삭제</a></td>
                           
                        </tr>
            <%
                    }
                }
            %>
        </tbody>
    </table>
</body>
</html>
