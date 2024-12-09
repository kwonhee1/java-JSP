package controller;

import java.io.IOException;
import java.util.ArrayList;

import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Board;
import model.User;
import repository.BoardRepository;
import service.BoardService;
import service.FileService;
import service.TokenService;

@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024*1024, maxRequestSize = 1024*1024*5)
@WebServlet("/BoardPage/*")
public class BoardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        System.out.println("BoardPage get() () >> action:"+action);
        if(action == null)
        	return;
        // 게시판 목록 return
        ArrayList<Board> boards = new BoardRepository().getBoardList(Integer.parseInt(action.substring(1)));
        //System.out.println("BoardPage >> check index0 : "+boards.get(0).toString());
        response.setStatus(HttpServletResponse.SC_OK);
        response.setContentType("application/json");
           
        ObjectMapper objectMapper = new ObjectMapper();
        String jsonResponse = objectMapper.writeValueAsString(boards);

        // Write JSON response
        response.getWriter().write(jsonResponse);
        return;
    }
    
    // new Board create : 동기 html form 태그 형식
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {    	
        System.out.println("Board Post(create) >> save img and update Board db");
    	//get User from token
        String userId = new TokenService().getUserIdFromToken(request, response);
        if(userId == null || userId.isBlank()) {
        	System.out.println("no token => return bad request");
        	response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        	return;
        }
        
        // input img 저장
        Part inputPart = request.getPart("img");
        int imgId = 2;
        if(inputPart != null) {
        	imgId = new FileService().saveFile((String)getServletContext().getAttribute("imgURL"), inputPart, 2);
        }else {
        	System.out.println("null file");
        }
    	// board 만들기 + get userId
    	Board newBoard = new Board(request.getParameter("title"), request.getParameter("content"),  Integer.parseInt(request.getParameter("gymId")), Integer.parseInt(request.getParameter("rate")));
    	
    	new BoardService().createBoard(newBoard, userId, imgId);
        
        response.setStatus(HttpServletResponse.SC_OK);
    }

    // update Board
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	System.out.println("board put");
    	int boardId =Integer.parseInt(request.getParameter("boardId"));
    	
    	System.out.println("Board Put(update) >> save new img again and update Board db BoardId="+String.valueOf(boardId));
    	//get User from token
        User user = new TokenService().getUserFromToken(request, response);
        if(user == null) {
        	return;
        }
        
        Part inputPart = request.getPart("img");
        
    	// board 만들기 + get userId
        //System.out.println(boardId+request.getParameter("title")+ request.getParameter("content")+String.valueOf(boardId)+","+request.getParameter("rate")+ inputPart.toString());
    	Board newBoard = new Board(boardId ,request.getParameter("title"), request.getParameter("content"), boardId, Integer.parseInt(request.getParameter("rate")));
    
    	new BoardService().updateBoard(newBoard, user, (String)getServletContext().getAttribute("imgURL"), inputPart);
        
        response.setStatus(HttpServletResponse.SC_OK);
        return;
    }

    // delete Board
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	String action = request.getPathInfo(); // /Project/BoardPage/3
    	System.out.println("Board delete(delete) "+action+">> get boardId, userId form token check same id and try delete Board");
       
       User inputUser = new TokenService().getUserFromToken(request, response);
       
       int boardId = Integer.parseInt(action.substring(1));// 해당 부분 수정 필요 url에서 get하는 방식으로
       
       // 삭제할 사람 확인 : 404
       
       new BoardService().removeBoard(boardId, (String)getServletContext().getAttribute("imgURL"), inputUser);
       
       response.setStatus(HttpServletResponse.SC_OK);
    }
}
