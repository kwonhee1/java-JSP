package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Gym;
import service.GymService;

import java.io.IOException;
import java.util.List;

@WebServlet("/Admin/AdminGym")
public class AdminGymController extends HttpServlet {
    private GymService gymService = new GymService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 검색된 헬스장 목록 또는 전체 헬스장 목록 조회
        String searchQuery = request.getParameter("search");
        List<Gym> gymList = (searchQuery != null && !searchQuery.isEmpty())
                ? gymService.searchGyms(searchQuery)
                : gymService.getAllGyms();

        request.setAttribute("gymList", gymList);

        // gym.jsp로 포워딩
        RequestDispatcher dispatcher = request.getRequestDispatcher("./AdminGym.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 헬스장 ID와 상태 값 가져오기
        String gymIdParam = request.getParameter("gymId");
        String newStatusParam = request.getParameter("status");

        // gymId와 status를 적절히 변환
        if (gymIdParam != null && newStatusParam != null) {
            try {
                int gymId = Integer.parseInt(gymIdParam);
                boolean newStatus = Boolean.parseBoolean(newStatusParam);

                // 서비스 호출
                gymService.updateGymStatus(gymId, newStatus);
            } catch (NumberFormatException e) {
                // 예외 처리: 잘못된 입력 값일 경우 로그를 남기거나 에러 페이지로 이동
                request.setAttribute("error", "Invalid gym ID or status value.");
            }
        }

        // 헬스장 목록 다시 조회
        List<Gym> gymList = gymService.getAllGyms();
        request.setAttribute("gymList", gymList);

        // gym.jsp로 포워딩
        RequestDispatcher dispatcher = request.getRequestDispatcher("/Admin/AdminGym.jsp");
        dispatcher.forward(request, response);
    }
}
