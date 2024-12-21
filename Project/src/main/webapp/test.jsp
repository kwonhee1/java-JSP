<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Google Login</title>
</head>
<body>
    <a id="google-login" href="#">Login with Google</a>

<script>
    // 페이지의 호스트 주소를 가져와서 dynamic URL 생성
    var redirectUri = "http://" + window.location.host + "/Project/oauth2/callback/google";

    var googleLoginUrl = "https://accounts.google.com/o/oauth2/v2/auth?client_id=97037992251-getttgeh5mjdnkbjfjleaif4vosr056h&redirect_uri=" + encodeURIComponent(redirectUri) + "&response_type=code&scope=openid%20email%20profile";

    // 링크의 href 속성에 Google 로그인 URL 설정
    document.getElementById("google-login").setAttribute("href", googleLoginUrl);
</script>
</body>
</html>
