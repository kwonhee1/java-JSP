package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import model.Gym;
import repository.MapRepository;
import service.TokenService;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/AdminGym")
public class AdminGymController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MapRepository mapRepository;

    @Override
    public void init() throws ServletException {
        mapRepository = new MapRepository();
    }

    // GET 요청 처리
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("doGet() 호출됨");

        // 폼 파라미터로 받은 gymName을 통해 헬스장 이름으로 필터링
        String gymNameparam = request.getParameter("gymName");
        ArrayList<Gym> gymList;

        // gymName이 제공되면 이름으로 필터링된 헬스장 목록을 가져옴
        if (gymNameparam != null && !gymNameparam.isEmpty()) {
            gymList = mapRepository.getGymsWithName(gymNameparam);
        } else {
            // gymName이 없으면 전체 헬스장 목록을 가져옴
            gymList = mapRepository.getAllGyms();
        }

        System.out.println("헬스장 갯수: " + gymList.size());
        
        // 헬스장 목록을 JSP에 전달
        request.setAttribute("gymList", gymList);
        
        // AdminGym.jsp 페이지로 포워딩
        RequestDispatcher dispatcher = request.getRequestDispatcher("Admin/AdminGym.jsp");
        dispatcher.forward(request, response);
    }

 // POST 요청 처리
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("doPost() 호출됨");
        
        if (!(new TokenService()).getUserFromToken(request, response).isAdmin()) {
        	System.out.println("is not  admin");
        	return;
        }

        // MapRepository 인스턴스 생성
        MapRepository mapRepository = new MapRepository();
        
        // 폼 파라미터 읽기
        String gymNameParam = request.getParameter("gymName");
        int newStatusParam = request.getParameter("status").equals("OPEN") ? 1 :0;

        System.out.println("수정 요청: gymName=" + gymNameParam + ", status=" + newStatusParam);

        // gymName에 해당하는 헬스장 목록 조회
        Gym gym = mapRepository.getGymAdmin(gymNameParam);

        // 헬스장 업데이트 로직
        if (gym != null) { // 정확히 하나의 헬스장이 검색된 경우
            System.out.println("업데이트할 헬스장 ID: " + gym.getId());
            mapRepository.updateGymStatus(gym.getId(), newStatusParam);
        } else {
            System.out.println("헬스장이 없거나, 여러 개가 검색되었습니다.");
        }
        
        request.setAttribute("gym",gym);

        // JSP 페이지로 포워딩하여 결과를 사용자에게 전달
        RequestDispatcher dispatcher = request.getRequestDispatcher("Admin/AdminGym.jsp");
        dispatcher.forward(request, response);
    }
}