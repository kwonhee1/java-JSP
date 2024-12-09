package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import model.Gym;
import repository.GymRepository;

import java.io.IOException;
import java.util.List;

@WebServlet("/AdminGym")
public class AdminGymController extends HttpServlet {
    private final GymRepository gymRepository = new GymRepository(); // Repository 사용

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchQuery = request.getParameter("search");
        List<Gym> gymList = (searchQuery != null && !searchQuery.isEmpty())
                ? gymRepository.searchGyms(searchQuery)
                : gymRepository.findAllGyms(); // Repository 호출

        request.setAttribute("gymList", gymList);

        RequestDispatcher dispatcher = request.getRequestDispatcher("Admin/AdminGym.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String gymIdParam = request.getParameter("gymId");
        String newStatusParam = request.getParameter("status");

        if (gymIdParam != null && newStatusParam != null) {
            try {
                int gymId = Integer.parseInt(gymIdParam);

                // newStatus를 String으로 처리
                gymRepository.updateGymStatus(gymId, newStatusParam); // Repository 호출
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid gym ID.");
            }
        }

        List<Gym> gymList = gymRepository.findAllGyms();
        request.setAttribute("gymList", gymList);

        RequestDispatcher dispatcher = request.getRequestDispatcher("Admin/AdminGym.jsp");
        dispatcher.forward(request, response);
    }
}
