<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    <style>
        /* 기본 스타일 */
        body {
            margin: 0;
            font-family: 'Black han Sans', serif;
            background-size: cover;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .container {
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.2);
            text-align: center;
        }

        .container h1 {
            font-size: 35px;
            margin-bottom: 20px;
            color: #000;
        }

        .form input[type="text"],
        .form input[type="password"],
        .form input[type="email"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
        }

        .container button {
            width: 100%;
            padding: 10px;
            background-color: #000;
            color: #fff;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }

        .container button:hover {
            background-color: #333;
        }

        .regist-container {
            width: 97%;
            padding: 5px;
            background-color: #000;
            color: #fff;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 10px;
        }

        #loginEmailKeySection {
            margin-top: 20px;
            display: none;
        }
    </style>
    <script>
        // 이메일 발송 비동기 함수
        async function sendEmail(event) {
            const id = document.getElementById('loginId').value;
            const email = document.getElementById('loginEmail').value;

            const user = { id, email };
            console.log(user);

            try {
                const response = await fetch('RegistPage', {
                    method: 'PUT',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(user),
                });

                if (response.ok) {
                    alert('인증 이메일을 발송했습니다. 이메일을 확인하세요.');
                    document.getElementById('loginEmailKeySection').style.display = 'block';
                } else if (response.status === 400) {
                    alert('중복된 ID입니다.');
                } else {
                    alert('이메일 발송 중 오류가 발생했습니다. 다시 시도해주세요.');
                }
            } catch (error) {
                console.error('Error:', error);
                alert('서버와의 연결에 문제가 발생했습니다.');
            }
        }

        async function register(event) {
            event.preventDefault();

            const id = document.getElementById('loginId').value;
            const passwd = document.getElementById('loginPasswd').value;
            const name = document.getElementById('loginName').value;
            const email = document.getElementById('loginEmail').value;
            const key = document.getElementById('loginKey').value;

            const user = { id, passwd, name, email, key };

            try {
                const response = await fetch('RegistPage', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(user),
                });

                if (response.ok) {
                    alert('회원 가입 성공');
                    toggleSideMenu2();
                    toggleSideMenu();
                } else if (response.status === 400) {
                    alert('잘못된 인증번호입니다');
                } else {
                    alert('회원가입 중 오류가 발생했습니다. 다시 시도해주세요.');
                }
            } catch (error) {
                console.error('Error:', error);
                alert('서버와의 연결에 문제가 발생했습니다.');
            }
        }
    </script>
</head>
<body>
    <div class="container">
        <h1>회원가입</h1>
        <form method="post" action="RegistPage">
            <div class="form">
                <input type="text" id="loginId" placeholder="ID" required><br>
                <input type="password" id="loginPasswd" placeholder="비밀번호" required><br>
                <input type="text" id="loginName" placeholder="이름" required><br>
                <input type="email" id="loginEmail" placeholder="이메일" required><br>
            </div>
            <button type="button" onclick="sendEmail(event)">인증 이메일 발송</button>

            <div id="loginEmailKeySection">
                <h2>이메일 인증</h2>
                <input type="text" id="loginKey" placeholder="인증 코드" required><br>
                <button type="button" onclick="register(event)">회원가입</button>
            </div>
        </form>
    </div>
</body>
</html>
