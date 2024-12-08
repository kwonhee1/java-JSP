package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import repository.BoardRepository;
import model.Board;

@WebServlet("/Admin/AdminBoard")
public class AdminBoardController extends HttpServlet {

    private BoardRepository boardRepository = new BoardRepository(); // BoardRepository 인스턴스 생성

    // GET 요청 처리 (게시판 조회)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String boardIdParam = request.getParameter("boardId");

        if (boardIdParam == null || boardIdParam.isEmpty()) {
            // boardId 파라미터가 없으면 전체 게시판 목록 가져오기
            try {
                ArrayList<Board> boardList = boardRepository.getAllBoardList();
                request.setAttribute("boardList", boardList);
                RequestDispatcher dispatcher = request.getRequestDispatcher("./AdminBoard.jsp");
                dispatcher.forward(request, response);
            } catch (Exception e) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to retrieve board list.");
                e.printStackTrace();
            }
            return;
        }

        try {
            // boardId가 전달되었으면 특정 게시판에 대한 작업 수행
            int boardId = Integer.parseInt(boardIdParam);
            Board board = boardRepository.getBoard(boardId);  // 특정 게시판 데이터 조회
            if (board != null) {
                request.setAttribute("board", board);
                RequestDispatcher dispatcher = request.getRequestDispatcher("./AdminBoard.jsp");
                dispatcher.forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Board not found.");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid boardId format.");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving board.");
            e.printStackTrace();
        }
    }

    // POST 요청 처리 (게시판 수정 기능)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String boardIdParam = request.getParameter("boardId");
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String imgURI = request.getParameter("imgURI");
        String rateParam = request.getParameter("rate");

        // 파라미터가 누락된 경우, BAD_REQUEST 오류 반환
        if (boardIdParam == null || title == null || content == null || rateParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameters.");
            return;
        }

        try {
            // boardId와 rate 값이 유효한지 검증
            int boardId = Integer.parseInt(boardIdParam);
            int rate = Integer.parseInt(rateParam);

            // Board 객체 생성
            Board board = new Board();
            board.setId(boardId);
            board.setTitle(title);
            board.setContent(content);
            board.setImgURI(imgURI);  // imgURI 값 설정
            board.setRate(rate);

            // 데이터베이스 업데이트 처리 부분 삭제됨

            response.sendRedirect(request.getContextPath() + "/Admin/AdminBoard"); // 수정 후 게시판 목록으로 리디렉션
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid boardId or rate format.");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error updating board.");
            e.printStackTrace();
        }
    }
}
