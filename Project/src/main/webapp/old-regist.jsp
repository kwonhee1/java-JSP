<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    <script>
        // 비동기 방식: 인증 이메일 발송
        async function sendEmail(event) {
            event.preventDefault(); // 기본 폼 제출 방지
            
            const id = document.querySelector('input[name="id"]').value;
            const passwd = document.querySelector('input[name="passwd"]').value;
            const name = document.querySelector('input[name="name"]').value;
            const email = document.querySelector('input[name="email"]').value;
            
            // 사용자 정보 객체 생성
            const user = {
                id: id,
                passwd: passwd,
                name: name,
                email: email
            };

            try {
                const response = await fetch('RegistPage', {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(user)
                });

                if (response.ok) {
                    alert('인증 이메일을 발송했습니다. 이메일을 확인하세요.');
                    document.querySelector('#emailKeySection').style.display = 'block'; // 이메일 키 입력 섹션 표시
                } else if(response.status === 400){
                    alert("중복된 id입니다");
                } else {
                    alert('이메일 발송 중 오류가 발생했습니다. 다시 시도해주세요.');
                }
            } catch (error) {
                console.error('Error:', error);
                alert('서버와의 연결에 문제가 발생했습니다.');
            }
        }
    </script>
</head>
<body>
    <h1>회원가입</h1>
    <form method="post" action="RegistPage">
        <!-- 숨겨진 메소드 값으로 PUT 사용 -->
        <input type="hidden" name="_method" value="PUT"/>
        
        아이디 : <input type="text" name="id" required> <br>
        비밀번호 : <input type="password" name="passwd" required> <br>
        이름 : <input type="text" name="name" required><br>
        이메일 : <input type="email" name="email" required><br>
        
        <!-- 인증 이메일 발송 버튼 (onclick으로 이벤트 호출) -->
        <button type="button" onclick="sendEmail(event)">인증 이메일 발송</button>

        <!-- 이메일 인증 코드 입력 섹션 -->
        <div id="emailKeySection" style="display: none;">
            <h2>이메일 인증</h2>
            인증 코드 : <input type="text" name="key" required> <br>
            <!-- 회원가입 처리 버튼 (폼 제출) -->
            <button type="submit">회원가입</button>
        </div>
    </form>

    <div>${reqeust.getAttribute("err")}</div>
</body>
</html>
