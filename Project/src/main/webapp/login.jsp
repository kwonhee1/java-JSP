<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://apis.google.com/js/platform.js" async defer></script>
<meta name="google-signin-client_id" content="YOUR_CLIENT_ID.apps.googleusercontent.com">
<meta charset="UTF-8">
<title>Login 페이지</title>
</head>
<style>
        /* 기본 스타일 */
         body {
            margin: 0;
            font-family: 'Black han Sans', serif;
            background: url('img/1-11.jpg');
            background-size: cover;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .login-container {
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.2);
            text-align: center;
        }

        .login-container h1 {
            font-size: 35px;
            margin-bottom: 20px;
            color: #000;
        }

        .login-container input[type="text"],
        .login-container input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
        }

        .login-container button {
            width: 100%;
            padding: 10px;
            background-color: #000;
            color: #fff;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }

        .login-container button:hover {
            background-color: #333;
        }
        
        .regist-container {
        	width: 97%;
            padding: 5px;
            background-color: #000;
            color: #fff;
            border-radius: 5px;
            align-items: center;
            font-size: 16px;
            cursor: pointer;
            margin-top: 10px;
        }
        #err {
            color: red;
        }
    </style>
</head>
<body>
    <div class="login-container" id="login-form">
        <h1>로그인</h1>
        <form>
            <input type="text" placeholder="ID" id="id" name="id" required>
            <input type="password" placeholder="비밀번호" id="passwd" name="passwd" required>
            <div id="err"></div>
            <button type="submit">로그인</button>
        </form>
        <br>
        <div class="social-login">
            <div class="g-signin2" data-onsuccess="onSignIn"></div>
        </div>
        <div class="regist-container" onclick="window.location.href='/Project/RegisterPage';">
    		회원가입
		</div>
    </div>
</body>
	<script>
	// 로그인 폼을 비동기로 처리하는 함수
    document.getElementById('login-form').addEventListener('submit', async function(event) {
        event.preventDefault();  // 기본 폼 전송 방지

        const id = document.getElementById('id').value;
        const passwd = document.getElementById('passwd').value;

        // 서버에 로그인 요청 (헤더에 ID와 패스워드를 포함하지 않고, JSON 형식으로 요청)
        const response = await fetch('LoginPage', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ id: id, passwd: passwd })
        });

        if (response.ok) {
            alert('Login successful!');
            window.location.href = '/Project/MainPage';  // 인증된 사용자 화면으로 리다이렉트
        } else if (response.status === 400) {  // 잘못된 요청 처리
            document.getElementById('err').textContent = 'ID 또는 패스워드가 일치하지 않습니다.';
        } else {
            alert('error');
        }
    });

    function onSignIn(googleUser) {
    	  var profile = googleUser.getBasicProfile();
    	  console.log('ID: ' + profile.getId()); // Do not send to your backend! Use an ID token instead.
    	  console.log('Name: ' + profile.getName());
    	  console.log('Image URL: ' + profile.getImageUrl());
    	  console.log('Email: ' + profile.getEmail()); // This is null if the 'email' scope is not present.
    	}
	</script>
</body>
</html>
