<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Google Login</title>
    <script src="https://accounts.google.com/gsi/client" async defer></script>
    <script>
    function handleCredentialResponse(response) {
        // Google로부터 ID Token을 받음
        const idToken = response.credential;

        // ID Token을 서버로 전송
        fetch('../Project/oauth2/callback/google', {
            method: 'post',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ token: idToken })
        })
        .then(res => {
            if (res.ok) {
                console.log("login success");
            } else {
                console.log("login fial")
            }
        })
        .catch(err => {
            console.error('Login error:', err);
        });
    }

    window.onload = function () {
        google.accounts.id.initialize({
            client_id: "97037992251-getttgeh5mjdnkbjfjleaif4vosr056h.apps.googleusercontent.com",
            callback: handleCredentialResponse
        });
        google.accounts.id.renderButton(
            document.getElementById("buttonDiv"),
            { theme: "outline", size: "large" }
        );
        
        google.accounts.id.initialize({
            client_id: "97037992251-getttgeh5mjdnkbjfjleaif4vosr056h.apps.googleusercontent.com",
            callback: handleCredentialResponse2
        });
        google.accounts.id.renderButton(
            document.getElementById("buttonDiv2"),
            { theme: "outline", size: "large" }
        );
    };
    
    function handleCredentialResponse2(response) {
        // Google로부터 ID Token을 받음
        const idToken = response.credential;

        // ID Token을 서버로 전송
        fetch('../Project/oauth2/callback/google', {
            method: 'put',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ token: idToken })
        })
        .then(res => {
            if (res.ok) {
                console.log("register success")
            } else {
                console.log("register fail")
            }
        })
        .catch(err => {
            console.error('register error:', err);
        });
    }
    </script>
</head>
<body>
    <h1>Google Login</h1>
    login
    <div id="buttonDiv"></div>
    
    register
    <div id="buttonDiv2"></div>
</body>
</html>
