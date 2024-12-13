<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    // User 데이터를 가져오기 위한 코드 (예시)
    User user = (new service.TokenService()).getUserFromToken(request, response);
	User reUser = (User)request.getAttribute("user");
	if(reUser != null){
		out.println("console.log('admin login');");
		user = reUser;
	}
	if(user!=null){
%>
<% String projectContextPath = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>프로필 수정</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        .profile-section {
            margin-bottom: 20px;
        }
        .profile-section span {
            display: inline-block;
            margin-right: 10px;
            font-weight: bold;
            cursor: pointer;
        }
        .profile-section input,
        .profile-section button {
            display: none;
        }
        .profile-section.edit-mode input,
        .profile-section.edit-mode button {
            display: inline-block;
            margin-top: 5px;
        }
        .profile-section.edit-mode span {
            display: none;
        }
    </style>
    <script>
 // 첫 번째 PUT 요청 함수
    async function updateUserData() {
        const userData = {
            name: document.querySelector('input[name="name"]').value,
            id: "<%= user.getId() %>",
            passwd: document.querySelector('input[name="password"]').value,
            email: document.querySelector('input[name="email"]').value
        };

        // 첫 번째 PUT 요청 - 이미지 제외한 데이터 전송
        try {
            const putResponse = await fetch('UserPage', {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(userData)
            });

            if (putResponse.status === 200) {
                // 200: 이미지 포함한 두 번째 POST 요청
                await updateUserImage();
            }else if(putResponse.status === 202){
            	alert('email또는 비밀번호가 변경되었습니다 email인증을 다시합니다');
            	addEmailVerificationInput();
            }
            else {
                alert('서버 처리 오류가 발생했습니다.');
            }
        } catch (error) {
            alert('서버와의 연결에 문제가 발생했습니다.');
        }
    }

    // 두 번째 POST 요청 (이미지 포함)
    async function updateUserImage() {
    	const formData = new FormData();

        const imageInput = document.querySelector('input[type="file"]');
        const imageFile = imageInput.files[0];
        
        // 이미지 파일이 있는 경우, FormData에 추가
        if (imageFile) {
            formData.append('img', imageFile);
        }

        // 다른 필드 값들도 FormData에 추가
        formData.append('name', document.querySelector('input[name="name"]').value);
        formData.append('id', "<%= user.getId() %>");
        formData.append('passwd', document.querySelector('input[name="password"]').value);
        formData.append('email', document.querySelector('input[name="email"]').value);

        const response = await fetch('UserPage', {
            method: 'POST',
            body: formData
        });

        if (response.status === 200) {
            // 200: 페이지 새로고침
            alert('프로필이 성공적으로 업데이트되었습니다!');
            location.reload();
        } else if (response.status === 400) {
            // 400: 이메일 인증 실패
            alert('이메일 인증 실패. 다시 시도해주세요.');
        } else if (response.status === 406) {
            // 406: ID 변경 불가 알림
            alert('ID값은 변경할 수 없습니다.');
        } else {
            alert('알 수 없는 오류가 발생했습니다.');
        }
    }

        // 이메일 인증 input 동적 추가 함수
        function addEmailVerificationInput() {
            const form = document.querySelector('form');
            
            // 이미 이메일 인증 input이 있다면 추가하지 않음
            if (document.getElementById('emailVerificationSection')) {
                return;
            }

            // 이메일 인증 섹션 생성
            const verificationSection = document.createElement('div');
            verificationSection.id = 'emailVerificationSection';
            verificationSection.innerHTML = `
                <label for="emailVerificationCode">이메일 인증 코드:</label>
                <input type="text" id="emailVerificationCode" placeholder="인증 코드를 입력하세요" />
                <button type="button" onclick="verifyEmailCode()">제출</button>
            `;
            form.appendChild(verificationSection);
        }


        // 이메일 인증 코드 제출 함수
        async function verifyEmailCode() {
            try {
                // 이메일 인증 데이터를 가져옴
                const verificationCode = document.getElementById('emailVerificationCode').value;

                // 기존 데이터와 이메일 인증 코드를 병합
                const userData = {
                    name: document.querySelector('input[name="name"]').value,
                    id: "<%= user.getId() %>",
                    passwd: document.querySelector('input[name="password"]').value,
                    email: document.querySelector('input[name="email"]').value,
                    verificationCode: verificationCode
                };

                // POST 요청 전송
                await submitUserData(userData);
            } catch (error) {
                alert('서버와 통신 중 오류가 발생했습니다.');
                console.error('오류:', error);
            }
        }
        function enableEdit(sectionId) {
            const section = document.getElementById(sectionId);
            section.classList.add('edit-mode');
        }

        function cancelEdit(sectionId) {
            const section = document.getElementById(sectionId);
            section.classList.remove('edit-mode');
        }
        async function deleteUser() {
            try {
                // Fetch 요청 전송
                const response = await fetch('./UserPage', {
                    method: 'delete', // HTTP DELETE 메서드 사용
                    headers: {
                        'Content-Type': 'application/json', // JSON 요청임을 명시
                    }
                });

                // 상태 코드에 따른 처리
                if (response.status === 200) {
                	eraseCookie();
                	alert('사용자 삭제 성공');
                	//window.location.href = './mainPage // 페이지 새로고침
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
    <h1>프로필 수정</h1>
    
    <form>
    <!-- 이미지 -->
        <div class="profile-section" id="imageSection">
            <img src="<%= projectContextPath+"/images/"+user.getImgURI() %>" alt="프로필 이미지" width="100" height="100" onclick="enableEdit('imageSection')"/>
            <br>
            <input type="file" name="img" />
            <button type="button" onclick="updateUserData()">이미지 수정</button>
        </div>
        <!-- 이름 -->
        <div class="profile-section" id="nameSection">
            <span onclick="enableEdit('nameSection')"><%= user.getName() %></span>
            <input type="text" name="name" value="<%= user.getName() %>" />
            <button type="button" onclick="updateUserData()">수정</button>
        </div>

        <!-- 아이디 -->
        <div class="profile-section" id="idSection">
            <span id="idDisplay"><%= user.getId() %></span>
            <!-- ID는 수정 불가능 -->
        </div>

        <!-- 비밀번호 -->
        <div class="profile-section" id="passwordSection">
            <span onclick="enableEdit('passwordSection')">●●●●●●●</span>
            <input type="password" name="password" value="<%= user.getPasswd() %>" />
            <button type="button" onclick="updateUserData()">수정</button>
        </div>

        <!-- 이메일 -->
        <div class="profile-section" id="emailSection">
            <span onclick="enableEdit('emailSection')"><%= user.getEmail() %></span>
            <input type="email" name="email" value="<%= user.getEmail() %>" />
            <button type="button" onclick="updateUserData()">수정</button>
        </div>
        
        <button onclick="deleteUser()">회원 탈퇴</button>
    </form>
</body>
</html>
<% } %>