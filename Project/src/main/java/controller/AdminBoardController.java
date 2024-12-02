package controller;

import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Board;
import repository.BoardRepository;

public class AdminBoardController {
    private BoardRepository boardRepository;

    public AdminBoardController() {
        this.boardRepository = new BoardRepository();
    }

    // 특정 Board 수정
    public void updateBoard(HttpServletRequest request, HttpServletResponse response) {
        try {
            int boardId = Integer.parseInt(request.getParameter("boardId"));
            String newTitle = request.getParameter("title");
            String newContent = request.getParameter("content");

            Board board = boardRepository.getBoardById(boardId);
            if (board != null) {
                board.setTitle(newTitle);
                board.setContent(newContent);
                boardRepository.updateBoard(board);
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().println("Board updated successfully.");
            } else {
            	response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().println("Board not found.");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 모든 Boards 검색
    public void getAllBoards(HttpServletRequest request, HttpServletResponse response) {
        try {
            List<Board> boards = boardRepository.getAllBoards();
            for (Board board : boards) {
                response.getWriter().println(board.toString());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
