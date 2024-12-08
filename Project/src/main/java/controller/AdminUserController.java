package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import repository.LoginRepository;

import java.io.IOException;
import java.util.List;

@WebServlet("/AdminUser")
public class AdminUserController extends HttpServlet {
    private LoginRepository loginRepository = new LoginRepository();

    // 사용자 목록 조회 (GET 요청 처리)
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<User> userList = loginRepository.getAllUsers(); // 모든 사용자 조회
            request.setAttribute("userList", userList);

            // 관리자 페이지로 포워딩
            RequestDispatcher dispatcher = request.getRequestDispatcher("Admin/AdminUser.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving users.");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = request.getParameter("userId");

        // userId로 해당 사용자 정보를 가져오기
        User user = (new LoginRepository()).getUserById(userId);

        // 디버깅용 출력: user 정보 확인
        System.out.println("Retrieved User: " + (user != null ? user.toString() : "User not found"));

        // request에 사용자 정보 설정
        request.setAttribute("user", user);

        // 디버깅용 출력: 포워딩 직전
        System.out.println("Forwarding to user.jsp with user data.");

        // user.jsp로 포워딩
        RequestDispatcher dispatcher = request.getRequestDispatcher("user.jsp");
        dispatcher.forward(request, response);
    }
}
