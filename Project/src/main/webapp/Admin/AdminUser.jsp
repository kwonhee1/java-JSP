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
        async function deleteUser(userId) {
            try {
                // Fetch 요청 전송
                const response = await fetch('./UserPage', {
                    method: 'delete', // HTTP DELETE 메서드 사용
                    headers: {
                        'Content-Type': 'application/json', // JSON 요청임을 명시
                    },
                    body: JSON.stringify({ id: userId }) // JSON 객체로 userId 전송
                });

                // 상태 코드에 따른 처리
                if (response.status === 200) {
                    alert('사용자 삭제 성공');
                    window.location.reload(); // 페이지 새로고침
                } else if (response.status === 400) {
                    alert('로그인 후 이용해주세요.');
                } else {
                    alert('알 수 없는 오류가 발생했습니다.');
                }
            } catch (error) {
                console.error('deleteUser() >> 네트워크 에러:', error);
                alert('서버와의 통신에 문제가 발생했습니다.');
            }
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
                            <td><button type="button" onclick="editUser('<%= user.getId() %>')">수정</button></td>
                            <td><button onclick="deleteUser('<%=user.id %>')">삭제</button></td>
                          <td><img src="<%=projectContextPath+"/images/"+user.getImgURI() %>" 
                            style="width: 100px; height: 100px;" />
</td>
                          
                            
                        </tr>
            <%
                    }
                }
            %>
        </tbody>
    </table>
</body>
</html>
