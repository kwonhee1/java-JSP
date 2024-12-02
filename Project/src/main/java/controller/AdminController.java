@WebServlet("/admin/dashboard")
public class AdminController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final LoginService loginService = new LoginService();
    private final GymService gymService = new GymService();
    private final BoardService boardService = new BoardService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 사용자 목록, 헬스장 목록, 게시판 목록 가져오기
        List<User> userList = loginService.getAllUsers();
        List<Gym> gymList = gymService.getAllGyms();
        List<Board> boardList = boardService.getAllBoards(); // 기본 게시판 목록

        // 검색된 데이터 설정
        request.setAttribute("userList", userList);
        request.setAttribute("gymList", gymList);
        request.setAttribute("boardList", boardList);

        // 관리 페이지로 포워딩
        request.getRequestDispatcher("/admin/admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("deleteUser".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            loginService.deleteUser(userId);  // 사용자 삭제
            response.sendRedirect("/admin/dashboard");
        } else if ("updateUser".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String newName = request.getParameter("name");
            String newEmail = request.getParameter("email");
            loginService.updateUser(userId, newName, newEmail);  // 사용자 정보 수정
            response.sendRedirect("/admin/dashboard");
        } else if ("updateGym".equals(action)) {
            int gymId = Integer.parseInt(request.getParameter("gymId"));
            boolean newStatus = Boolean.parseBoolean(request.getParameter("status"));
            gymService.updateGymStatus(gymId, newStatus);  // 헬스장 상태 업데이트
            response.sendRedirect("/admin/dashboard");
        } else if ("deleteBoard".equals(action)) {
            int boardId = Integer.parseInt(request.getParameter("boardId"));
            boardService.deleteBoard(boardId);  // 게시글 삭제
            response.sendRedirect("/admin/dashboard");
        } else if ("updateBoard".equals(action)) {
            int boardId = Integer.parseInt(request.getParameter("boardId"));
            String newTitle = request.getParameter("title");
            String newContent = request.getParameter("content");
            boardService.updateBoard(boardId, newTitle, newContent);  // 게시글 수정
            response.sendRedirect("/admin/dashboard");
        } else if ("searchGym".equals(action)) {
            String gymName = request.getParameter("gymName");
            List<Gym> gymSearchResult = gymService.searchGymsByName(gymName);  // gym 이름으로 검색
            request.setAttribute("gymList", gymSearchResult);
            request.getRequestDispatcher("/admin/admin.jsp").forward(request, response);
        } else if ("viewBoardsForGym".equals(action)) {
            int gymId = Integer.parseInt(request.getParameter("gymId"));
            List<Board> boardsForGym = boardService.getBoardsByGymId(gymId);  // 특정 gym에 해당하는 게시판 목록 검색
            request.setAttribute("boardList", boardsForGym);
            request.getRequestDispatcher("/admin/admin.jsp").forward(request, response);
        }
    }
}
