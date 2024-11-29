<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
	<%@ page import="service.TokenService" %>
	<%@ page import="model.User" %>
<!DOCTYPE html>
<html>
<head>
<script src="https://apis.google.com/js/platform.js" async defer></script>
<meta charset="UTF-8">
<meta name="google-signin-client_id" content="YOUR_CLIENT_ID.apps.googleusercontent.com">
<title>Login 페이지</title>
</head>
<script>
	
	<%// 토큰이 유효한지 확인
    	TokenService tokenService = new TokenService();
		User user = tokenService.getUserFromToken(request, response);
		if(user != null){%>
			alert("already login")
			window.location = "/Project/MainPage" //이전 화면으로 되돌리기 변경 필요
        	<%
		}
	%>


</script>
<style>
        /* 기본 스타일 */
        body {
            margin: 0;
            font-family: 'Black han Sans', serif;
            background: url('img/1-11.jpg');
            background-size: cover;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .login-container {
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            padding: 30px;
            width: 320px;
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

        .social-login {
            display: flex;
            justify-content: space-between;
            margin-top: 15px;
        }

        .social-login a {
            display: inline-block;
            width: 48%;
            text-align: center;
            padding: 10px;
            border-radius: 10px;
            text-decoration: none;
            font-size: 14px;
        }

        .kakao-login {
            background-color: #FFEB00;
            color: #000000;
        }

        .naver-login {
            background-color: #03C75A;
        }
        
        .google-login {
        	background-color: turquoise;
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
    </style>
</head>
<body>
    <div class="login-container">
        <h1>로그인</h1>
        <form>
            <input type="text" placeholder="ID" required>
            <input type="password" placeholder="비밀번호" required>
            <button type="submit">로그인</button>
        </form>
        <div class="social-login">
            <a href="errorpage.jsp" class="kakao-login">카카오 로그인</a>
            <a href="#" class="naver-login">네이버 로그인</a>
            <a href="#" class="google-login">구글 로그인</a>
        </div>
        <div class="regist-container">
        	<a href="regist.jsp"> 회원가입(여기로!!)</a>
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
    	var google_token = googleUser.getAuthResponse().id_token;
    	// server back 으로 token값을 넘김 url : LoginPage/google / post방식
    }
	</script>
</body>
</html>
