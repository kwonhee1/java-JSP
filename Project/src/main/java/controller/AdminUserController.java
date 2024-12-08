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

@WebServlet("/Admin/AdminUser")
public class AdminUserController extends HttpServlet {
    private LoginRepository loginRepository = new LoginRepository();

    // 사용자 목록 조회 (GET 요청 처리)
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<User> userList = loginRepository.getAllUsers(); // 모든 사용자 조회
            request.setAttribute("userList", userList);

            // 관리자 페이지로 포워딩
            RequestDispatcher dispatcher = request.getRequestDispatcher("./AdminUser.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving users.");
        }
    }

    // 사용자 수정 (POST 요청 처리)
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = request.getParameter("userId");
        String name = request.getParameter("name");
        String passwd = request.getParameter("passwd");
        String email = request.getParameter("email");

        if (userId == null || userId.isEmpty() || name == null || name.isEmpty() ||
            passwd == null || passwd.isEmpty() || email == null || email.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing or invalid user parameters.");
            return;
        }

        try {
            User user = loginRepository.getUserById(userId);
            if (user == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found.");
                return;
            }

            int imgId = loginRepository.getImgId(userId); // 이미지는 별도로 가져오기

            user.setName(name);
            user.setPasswd(passwd);
            user.setEmail(email);
            

            loginRepository.updateUser(user, imgId); // 사용자 정보 업데이트

            // 사용자 목록을 다시 가져와서 화면에 표시
            List<User> userList = loginRepository.getAllUsers();
            request.setAttribute("userList", userList);

            // 수정 후 관리자 페이지로 포워딩
            RequestDispatcher dispatcher = request.getRequestDispatcher("./AdminUser.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error updating user.");
        }
    }
    
}
