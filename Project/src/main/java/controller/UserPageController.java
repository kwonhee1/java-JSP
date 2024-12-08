package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.User;
import repository.LoginRepository;
import service.EmailService;
import service.FileService;
import service.TokenService;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.Map;

import com.fasterxml.jackson.databind.ObjectMapper;

// login 상태에서만 접근 가능 / 확인 필수
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024*1024, maxRequestSize = 1024*1024*5)
@WebServlet("/UserPage")
public class UserPageController extends HttpServlet {
	//private static final long serialVersionUID = 1L;
    
    public UserPageController() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		User inputUser = new TokenService().getUserFromToken(request, response);
		request.setAttribute("user", inputUser);
		
		System.out.println("UserPage get() return userPage.jsp");
		
		request.getRequestDispatcher("userPage.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		User oldUser = new TokenService().getUserFromToken(request, response);
		String inputUserEmail = request.getParameter("email");
		String inputUserId = request.getParameter("id");
		User inputUser = new User(inputUserId, request.getParameter("passwd"), request.getParameter("name"), inputUserEmail);
		
		System.out.println("UserPage post() : edit user data inputUser:"+ inputUser.toString()+", oldUser:"+oldUser.toString());
		
		// token의 id와 input된 id값이 동일 해야함
		// email이 변경되면 다시 인증
		if(oldUser == null || !oldUser.getId().equals(inputUserId)) {
			System.out.println("user id is changed return alert page.jsp");
			request.setAttribute("err", "사용자의 id값은 변경할수 없습니다");
			response.setStatus(HttpServletResponse.SC_NOT_ACCEPTABLE);
			return;
		}
		if(!oldUser.getEmail().equals(inputUserEmail) && !oldUser.isAdmin()) {
			// email 인증 다시 확인
			if(!new EmailService().checkByKeyCode(inputUserId, (String)request.getParameter("key"))) {
				System.out.println("not correct email key => return 400");
				response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
				return;
			}
		}
		
		System.out.println("UserPage Post -> emailcheck success -> try update file and update user DB");
		
		FileService fileService = new FileService();
		LoginRepository loginRepository = new LoginRepository();
		String imgURL = (String)getServletContext().getAttribute("imgURL");
		
		// user img를 가져오고 해당 img를 업데이트함
		Part inputPart = request.getPart("img");
		int imgId;
		if(inputPart != null) {
			System.out.println("UserPage post() : new img -> check default and remove and update");
			
			// 이전 user의 img uri를 가져옴 => default사진이 아니라면 삭제
			if(!oldUser.getImgURI().equals("default.png")) {
				// erase img
				fileService.removeImg(imgURL, loginRepository.getImgId(oldUser.getId()));
			}
			// 새로운 img파일 저장
			imgId = fileService.saveFile(imgURL, inputPart, 1);
		}else {
			System.out.println("UserPage post() >> not input img >> use older img");
			imgId = loginRepository.getImgId(inputUserId);
		}
		
		loginRepository.updateUser(inputUser, imgId);
		
		//redirect
		response.setStatus(HttpServletResponse.SC_OK);
		return;
	}
	
	protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		// JSON 데이터를 Map으로 변환
		User input = (new ObjectMapper()).readValue(request.getReader().readLine(), User.class);
		System.out.println(input.toString());
		
		// 데이터 추출
	    String inputUserEmail = input.getEmail();
	    String inputUserId = input.getId();
		
		User oldUser = new TokenService().getUserFromToken(request, response);
		
		System.out.println("UserPage put() >> input user (id,email)=("+inputUserId +","+inputUserEmail+") old=("+oldUser.getId()+","+oldUser.getEmail()+")");
		
		// token의 id와 input된 id값이 동일 해야함
		// email이 변경되면 다시 인증
		if(oldUser == null || (!oldUser.getId().equals(inputUserId) && !oldUser.isAdmin()) ) {
			System.out.println("UserPage Put() >> no login or not same user);
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			return;
		}
		if(!oldUser.getEmail().equals(inputUserEmail) && !oldUser.isAdmin()) {
			System.out.println("check email agin");
			// email 인증 다시
			new EmailService().sendEmail(inputUserId, inputUserEmail);
			response.setStatus(HttpServletResponse.SC_ACCEPTED);
			return;
		}else {
			System.out.println("not requred check email just commit");
			response.setStatus(HttpServletResponse.SC_OK);
			return;
		}
	}
	
	protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}
}
