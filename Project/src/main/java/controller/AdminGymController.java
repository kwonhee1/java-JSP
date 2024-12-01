package controller;

import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Gym;
import repository.MapRepository;

@WebServlet("/admin/gym")
public class AdminGymController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final MapRepository gymRepository = new MapRepository(); // Gym 데이터 접근 객체

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchQuery = request.getParameter("searchQuery");

        List<Gym> gyms;
        if (searchQuery != null && !searchQuery.isEmpty()) {
            gyms = gymRepository.searchGyms(searchQuery); // 검색 결과 가져오기
        } else {
            gyms = gymRepository.findAllGyms(); // 모든 헬스장 정보 가져오기
        }

        request.setAttribute("gyms", gyms);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/admin/gymList.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int gymId = Integer.parseInt(request.getParameter("gymId"));
        String newStatus = request.getParameter("status");

        gymRepository.updateGymStatus(gymId, newStatus); // 헬스장 상태 업데이트

        response.sendRedirect(request.getContextPath() + "/admin/gym");
    }
}
