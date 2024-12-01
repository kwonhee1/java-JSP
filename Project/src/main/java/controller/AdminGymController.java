package controller;

import service.GymService;
import model.Gym;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/admin/gym")
public class AdminGymController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final GymService gymService = new GymService(); // GymService 사용

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchQuery = request.getParameter("searchQuery");

        List<Gym> gymList;
        if (searchQuery != null && !searchQuery.isEmpty()) {
            gymList = gymService.searchGyms(searchQuery); // 검색 기능
        } else {
            gymList = gymService.getAllGyms(); // 전체 목록 가져오기
        }

        request.setAttribute("gymList", gymList);
        request.getRequestDispatcher("Admin/admin.jsp").forward(request, response); // JSP로 포워딩
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int gymId = Integer.parseInt(request.getParameter("gymId"));
        boolean newStatus = Boolean.parseBoolean(request.getParameter("status"));

        gymService.updateGymStatus(gymId, newStatus); // 상태 업데이트

        response.sendRedirect(request.getContextPath() + "/admin/gym"); // 목록으로 리다이렉트
    }
}
