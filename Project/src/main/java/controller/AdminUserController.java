package controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import service.LoginService;

import java.io.IOException;

@WebServlet("/admin/user")
public class AdminUserController extends HttpServlet {
    private LoginService loginService =new LoginService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("userList", loginService.getAllUsers());  // 로그인 서비스에서 모든 사용자 조회
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/userList.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            loginService.deleteUser(userId);  // 삭제 로직 추가
            response.sendRedirect("/admin/userList");
        } else if ("update".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String newName = request.getParameter("name");
            String newEmail = request.getParameter("email");
            loginService.updateUser(userId, newName, newEmail);  // 유저 정보 업데이트
            response.sendRedirect("/admin/userList");
        }
    }
    
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	int userId = Integer.parseInt(request.getParameter("userId"));
        String newName = request.getParameter("name");
        String newEmail = request.getParameter("email");
        loginService.updateUser(userId, newName, newEmail);  // 유저 정보 업데이트
        response.sendRedirect("/admin/userList");
    }
    
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	int userId = Integer.parseInt(request.getParameter("userId"));
        loginService.deleteUser(userId);  // 삭제 로직 추가
        response.sendRedirect("/admin/userList");
    }
}
