<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 페이지</title>
</head>
<body>
    <h1>관리자 페이지</h1>
    <ul>
        <li><a href="AdminBoard">게시판 관리</a></li>
        <li><a href="AdminGym">헬스장 관리</a></li>
        <li><a href="AdminUser">사용자 관리</a></li>
    </ul>
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
