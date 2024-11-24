package controller;

import java.io.IOException;
import java.util.Date;
import java.util.Optional;

import com.fasterxml.jackson.databind.ObjectMapper;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import service.LoginService;
import service.TokenService;

@WebServlet("/LoginPage")
public class LoginController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private LoginService loginService = new LoginService();

	// login 페이지 return
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//doGet(request, response);
		System.out.println("Login get() >> return login.jsp");
		request.getRequestDispatcher("login.jsp").forward(request, response);
		
	}

	// login 기능
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		
		User input = (new ObjectMapper()).readValue(request.getReader().readLine(), User.class);

		System.out.println(input.getId() + ", " + input.getPasswd() + " Login post() >> check login");
		
		User user = loginService.isUser(input);
		if(user == null) {
			// login fail => 현재 : adduser
			System.out.println("login fail return login.jsp + err");
//			request.setAttribute("err", "login fail");
//			request.getRequestDispatcher("login.jsp").forward(request, response);
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Login fail");
		}
		else {
			// login success
			
            // session 발급 밑 정보 저장
			//request.getSession().setAttribute("name", input.getName());
			
			response.setContentType("application/json");
			
			//token 발급
			String token = Jwts.builder()
                    .setSubject(user.getId())
                    .claim("name", user.getName())
                    .setIssuedAt(new Date())
                    .setExpiration(new Date(System.currentTimeMillis() + 60 * 60 * 1000)) // 1시간 유효
                    .signWith(SignatureAlgorithm.HS256, TokenService.getSecretKey())
                    .compact();
			
			 // JWT를 쿠키에 저장
            Cookie cookie = new Cookie("token", token);
            cookie.setHttpOnly(false);  // JS에서 접근하지 못하도록 설정
            cookie.setMaxAge(60 * 60);  // 쿠키 유효시간 설정 (1시간)
            cookie.setPath("/");  // 쿠키의 유효 경로
            response.addCookie(cookie);  // 클라이언트로 쿠키 전송

            // 응답 상태 200 OK
            response.setStatus(HttpServletResponse.SC_OK);
			
            System.out.println("login success => publish token");
			// send main page
			//response.sendRedirect("/Project");
		}
	}

}
