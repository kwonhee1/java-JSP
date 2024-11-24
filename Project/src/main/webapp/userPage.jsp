<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    User user = (User) request.getAttribute("user");
	String path = request.getContextPath();
    if (user == null) {
%>
        <script>
            alert("로그인 후 이용해주세요.");
            window.location = "/Project/MainPage";
        </script>
<%
    }else{
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원 정보 수정</title>
    <script>
        // 이메일 확인 버튼 클릭 이벤트
        document.addEventListener('DOMContentLoaded', () => {
            const emailCheckBtn = document.getElementById('emailCheckBtn');
            emailCheckBtn.addEventListener('click', async () => {
                const email = document.getElementById('email').value;
                const id = document.getElementById('id').value;

                try {
                    const response = await fetch('UserPage', {
                        method: 'PUT',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ id, email })
                    });

                    if (response.status == 202) { // accepted
                        document.getElementById('emailKeySection').style.display = 'block';
                    	document.getElementById('finalSubmitBtn').style.display = 'block';
                        alert("인증 이메일이 발송되었습니다. 이메일을 확인해주세요.");
                    } else if (response.status == 200) { // OK
                        document.getElementById('finalSubmitBtn').style.display = 'block';
                        alert("이전 이메일과 동일합니다. 이메일인증을 생략합니다");
                    } else if (response.status == 400) { // BAD_REQUEST
                        alert("ID는 변경할 수 없습니다. 다시 확인해주세요.");
                    } else {
                        alert("이메일 인증 중 오류가 발생했습니다.");
                    }
                } catch (error) {
                    console.error('Error:', error);
                    alert('서버와 연결 중 문제가 발생했습니다.');
                }
            });
        });
    </script>
</head>
<body>
    <h1>회원 정보 수정</h1>
    <form id="user-form" action="UserPage" method="post" enctype="multipart/form-data">
        <div>
            <label for="id">아이디:</label>
            <input type="text" id="id" name="id" value="<%= user.getId() %>" readonly required>
        </div>
        <div>
            <label for="passwd">비밀번호:</label>
            <input type="text" id="passwd" name="passwd" value=<%= user.getPasswd() %> required>
        </div>
        <div>
            <label for="name">이름:</label>
            <input type="text" id="name" name="name" value="<%= user.getName() %>" required>
        </div>
        <div>
            <label for="email">이메일:</label>
            <input type="text" id="email" name="email" value="<%= user.getEmail() %>" required>
        </div>
        <div>
            <label for="img">프로필 이미지:</label>
            <img id="current-img" src="<%=path+"/images/"+ user.getImgURI() %>" alt="Current Profile Image" width="100">
            <input type="file" id="img" name="img">
        </div>
        <div>
            <button type="button" id="emailCheckBtn">이메일 확인</button>
        </div>

        <!-- 이메일 인증 코드 입력 섹션 -->
        <div id="emailKeySection" style="display: none;">
            이메일 인증 코드: <input type="text" id="key" name="key">
        </div>

        <!-- 최종 제출 버튼 -->
        <div id="finalSubmitBtn" style="display: none;">
            <button type="submit">정보 수정</button>
        </div>
    </form>
</body>
</html>
<% } %>