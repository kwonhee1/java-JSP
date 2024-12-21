<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Google Login</title>
    <meta name="google-signin-client_id" content="97037992251-getttgeh5mjdnkbjfjleaif4vosr056h.apps.googleusercontent.com">
    <script src="https://apis.google.com/js/platform.js" async defer></script>
    <script>
    function onSignIn(googleUser) {
    	  var profile = googleUser.getBasicProfile();
    	  console.log('ID: ' + profile.getId()); // Do not send to your backend! Use an ID token instead.
    	  console.log('Name: ' + profile.getName());
    	  console.log('Image URL: ' + profile.getImageUrl());
    	  console.log('Email: ' + profile.getEmail()); // This is null if the 'email' scope is not present.
    	}
    </script>
</head>
<body>
    <h1>Google Login</h1>
    <div class="g-signin2" data-onsuccess="onSignIn"></div>
</body>
</html>