<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Board" %>
<% String projectContextPath = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시판 관리</title>
    <script>
    async function deleteBoard(boardId) {
        try {
            // DELETE 요청을 보냄
            const response = await fetch("<%=projectContextPath%>/BoardPage/"+boardId, {
                method: 'DELETE',
            });

            // 응답 처리
            switch (response.status) {
                case 200:
                    alert("삭제 완료");
                    showBoard(selected.id); // 삭제 후 게시판 목록 갱신
                    break;
                case 404:
                    alert("작성자가 아닙니다.");
                    break;
                default:
                    alert("서버 오류가 발생했습니다.");
                    break;
            }
        } catch (error) {
            console.error("Error deleting board item:", error);
            alert("서버 요청 중 오류가 발생했습니다.");
        }
    }
    </script>
</head>
<body>
    <h1>게시판 관리</h1>
    <table border="1">
        <thead>
            <tr>
                <th>게시판 ID</th>
                <th>제목</th>
                <th>내용</th>
                <th>작성자</th>
                <th>작성일</th>
                <th>수정</th>
                <td>삭제</th>
            </tr>
        </thead>
        <tbody>
            <%
                List<Board> boardList = (List<Board>) request.getAttribute("boardList");
                if (boardList != null && !boardList.isEmpty()) {
                    for (Board board : boardList) {
            %>
                        <tr>
                            <td><%= board.getId() %></td>
                            <td><%= board.getTitle() %></td>
                            <td><%= board.getContent() %></td>
                            <td><%= board.getUserName() %></td>
                            <td><%= board.getCreatedAt() %></td>
                            <td><a href="./AdminBoard?boardId=<%= board.getId() %>">수정</a></td>
                            <td><button onclick="deleteBoard(<%=board.getId()%>)">삭제</button></td>
                        </tr>
            <%
                    }
                } else {
            %>
                    <tr>
                        <td colspan="6">게시판 데이터가 없습니다.</td>
                    </tr>
            <%
                }
            %>
        </tbody>
    </table>

    <hr>

    <%
        Board board = (Board) request.getAttribute("board");
        if (board != null) {
    %>
        <h2>게시판 수정</h2>
        <form action="./AdminBoard" method="post">
            <input type="hidden" name="boardId" value="<%= board.getId() %>">
            <label for="title">제목:</label>
            <input type="text" id="title" name="title" value="<%= board.getTitle() %>" required><br><br>
            
            <label for="content">내용:</label><br>
            <textarea id="content" name="content" required><%= board.getContent() %></textarea><br><br>
            
            <label for="imgURI">이미지 URL:</label>
            <input type="text" id="imgURI" name="imgURI" value="<%= board.getImgURI() %>"><br><br>
            
            <label for="rate">평점:</label>
            <input type="number" id="rate" name="rate" value="<%= board.getRate() %>" min="1" max="5" required><br><br>
            
            <button type="submit">수정</button>
        </form>
    <%
        }
    %>
</body>
</html>
