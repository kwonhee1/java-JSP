<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<% String projectContextPath = request.getContextPath(); %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>사용자 관리</title>
    <script>
        // 수정 버튼 클릭 시 해당 사용자의 정보를 서버로 전달하고 user.jsp로 포워딩
        function editUser(userId) {
            // Ajax를 이용하여 서버에서 사용자 정보를 가져올 수 있지만, 간단히
            // form을 이용하여 user.jsp로 포워딩하는 방식으로 구현할 수도 있음.
            var form = document.createElement("form");
            form.method = "post";
            form.action = "./AdminUser";
            
            var input = document.createElement("input");
            input.type = "hidden";
            input.name = "userId";
            input.value = userId;
            form.appendChild(input);

            document.body.appendChild(form);
            form.submit();
        }
    </script>
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
                            <td><button type="button" onclick="editUser('<%= user.getId() %>')">수정</button></td>
                            <td><a href="./DeleteUser?userId=<%= user.getId() %>">삭제</a></td>
                            <td><%= projectContextPath+"/images/"+user.getImgURI() %>
                        </tr>
            <%
                    }
                }
            %>
        </tbody>
    </table>
</body>
</html>
