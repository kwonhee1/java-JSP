<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Map Page</title>
</head>

<body>
<h1>MapPage</h1>

<form action="MapPage" method="POST">
    <input type="hidden" name="_method" value="reload" />
    <button type="submit">Map load</button>
</form>

<form action="MapPage" method="POST">
    <input type="hidden" name="_method" value="update" />
    <button type="submit">Map update</button>
</form>

</body>
</html>
