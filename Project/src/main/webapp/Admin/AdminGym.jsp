<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Gym" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>헬스장 수정</title>
</head>
<body>
    <h1>헬스장 수정</h1>

    <!-- 헬스장 목록 출력 -->
    <table border="1">
        <thead>
            <tr>
                <th>헬스장 이름</th>
                <th>상태</th>
                <th>수정</th>
            </tr>
        </thead>
        <tbody>
            <%
                // Controller에서 전달된 헬스장 목록 가져오기
                @SuppressWarnings("unchecked")
                List<Gym> gymList = (List<Gym>) request.getAttribute("gymList");

                if (gymList != null && !gymList.isEmpty()) {
                    for (Gym gym : gymList) {
                        // 상태 데이터는 다른 필드로 가정
                        String gymName = gym.getName(); // 이름 가져오기
                        String gymStatus =String.valueOf(gym.status);// 요청에서 상태 값 가져오기
            %>
            <tr>
                <!-- 헬스장 이름 출력 -->
                <td><%= gymName %></td>
                <!-- 헬스장 상태 출력 -->
                <td><%= gymStatus%></td>
                <!-- 수정 폼 -->
                <td>
                    <form action="<%= request.getContextPath() %>/AdminGym" method="post">
                        <!-- 헬스장 이름 전달 -->
                        <input type="hidden" name="gymName" value="<%= gymName %>">
                        <!-- 상태 선택 -->
                        <select name="status">
                            <option value="OPEN" <%= "OPEN".equals(gymStatus) ? "selected" : "" %>>OPEN</option>
                            <option value="CLOSED" <%= "CLOSED".equals(gymStatus) ? "selected" : "" %>>CLOSED</option>
                        </select>
                        <button type="submit">저장</button>
                    </form>
                </td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="4">헬스장 데이터가 없습니다.</td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>

    <!-- 목록 페이지로 이동 -->
    <a href="<%= request.getContextPath() %>/AdminGym">목록으로</a>
</body>
</html>
