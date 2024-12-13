<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Gym" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>헬스장 수정</title>
    <style>
        /* 제목과 버튼을 같은 줄에 배치 */
        .header-container {
            display: flex;
            align-items: center; /* 세로 가운데 정렬 */
        }
        /* 버튼 간격 최소화 */
        .action-buttons form {
            display: inline;
            margin: 0;
            padding: 0;
        }
        .action-buttons button {
            margin-left: 5px; /* 제목과 버튼 간, 버튼 간 최소 간격 */
            padding: 5px 10px; /* 버튼 내부 여백 최소화 */
        }
    </style>
</head>
<body>
    <div class="header-container">
        <h1 style="margin: 0;">헬스장 수정</h1>
        <div class="action-buttons">
            <form action="MapPage" method="POST">
                <input type="hidden" name="_method" value="reload" />
                <button type="submit">Map load</button>
            </form>
            <form action="MapPage" method="POST">
                <input type="hidden" name="_method" value="update" />
                <button type="submit">Map update</button>
            </form>
        </div>
    </div>

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
                @SuppressWarnings("unchecked")
                List<Gym> gymList = (List<Gym>) request.getAttribute("gymList");

                if (gymList != null && !gymList.isEmpty()) {
                    for (Gym gym : gymList) {
                        String gymName = gym.getName();
                        String gymStatus = String.valueOf(gym.status);
            %>
            <tr>
                <td><%= gymName %></td>
                <td><%= gymStatus %></td>
                <td>
                    <form action="<%= request.getContextPath() %>/AdminGym" method="post">
                        <input type="hidden" name="gymName" value="<%= gymName %>">
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
