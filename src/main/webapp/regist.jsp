<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	Register<br>
	<form action="Regist" method="post">
		id : <input type="text" name="id"> <br>
		passwd : <input type="password" name="passwd"> <br>
		name : <input type="text" name="name"><br>
		<button type="submit"> Register </button>
	</form>
	${err }
</body>
</html>