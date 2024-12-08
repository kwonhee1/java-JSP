<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <title>헬스장 관리</title>
</head>
<body>
    <h1>헬스장 관리</h1>
    <table border="1">
        <thead>
            <tr>
                <th>헬스장 ID</th>
                <th>헬스장 이름</th>
                <th>상태</th>
                <th>수정</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="gym" items="${gymList}">
                <tr>
                    <td>${gym.gymId}</td>
                    <td>${gym.name}</td>
                    <td>${gym.status}</td>
                    <td><a href="./AdminGym?gymId=${gym.gymId}">수정</a></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>
