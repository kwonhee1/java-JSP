package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import repository.LoginRepository;
import service.LoginService;
import service.TokenService;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Date;
import java.util.Map;
import java.util.Scanner;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;

@WebServlet("/oauth2/callback/google")
public class google extends HttpServlet {
	private static final String GOOGLE_TOKEN_INFO_URL = "https://oauth2.googleapis.com/tokeninfo?id_token=";
	
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	System.out.println("Google login post() >> try get token from google");
        ObjectMapper mapper = new ObjectMapper();
        JsonNode jsonNode = mapper.readTree(request.getInputStream());
        String token = jsonNode.get("token").asText();

        // 토큰 검증
        URL url = new URL(GOOGLE_TOKEN_INFO_URL + token);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.connect();

        int responseCode = conn.getResponseCode();
        if (responseCode != 200) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Invalid token");
            return;
        }

        Scanner scanner = new Scanner(url.openStream());
        StringBuilder inline = new StringBuilder();
        while (scanner.hasNext()) {
            inline.append(scanner.nextLine());
        }
        scanner.close();

        JsonNode tokenInfo = mapper.readTree(inline.toString());

        // 사용자 정보 가져오기
        String passwd = tokenInfo.get("sub").asText();
        String email = tokenInfo.get("email").asText();
        String name = tokenInfo.get("name").asText();

        System.out.println("Google post() >> recive user info from google try login" +email + passwd + name);
        
        User user = new LoginService().isUser(new User(email, passwd, name, email));
        if (user == null) {
        	System.out.println("login fail return bad request");
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }else {
        	//token 발급
			String token2 = Jwts.builder()
                    .setSubject(user.getId())
                    .claim("ip", request.getRemoteAddr()) // 클라이언트 IP 포함
                    .claim("userAgent", request.getHeader("User-Agent")) // User-Agent 포함
                    .setIssuedAt(new Date())
                    .setExpiration(new Date(System.currentTimeMillis() + 60 * 60 * 1000)) // 1시간 유효
                    .signWith(SignatureAlgorithm.HS256, TokenService.getSecretKey())
                    .compact();
			
			 // JWT를 쿠키에 저장
            Cookie cookie = new Cookie("token", token2);
            cookie.setHttpOnly(false);  // JS에서 접근하지 못하도록 설정
            cookie.setMaxAge(60 * 60);  // 쿠키 유효시간 설정 (1시간)
            cookie.setPath("/");  // 쿠키의 유효 경로
            response.addCookie(cookie);  // 클라이언트로 쿠키 전송

            // 응답 상태 200 OK
            response.setStatus(HttpServletResponse.SC_OK);
			
            System.out.println("loginPage post >> publish token success return 200");
        }
    }
    
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	System.out.println("Google login put() >> try get token from google");
        ObjectMapper mapper = new ObjectMapper();
        JsonNode jsonNode = mapper.readTree(request.getInputStream());
        String token = jsonNode.get("token").asText();

        // 토큰 검증
        URL url = new URL(GOOGLE_TOKEN_INFO_URL + token);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.connect();

        int responseCode = conn.getResponseCode();
        if (responseCode != 200) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Invalid token");
            return;
        }

        Scanner scanner = new Scanner(url.openStream());
        StringBuilder inline = new StringBuilder();
        while (scanner.hasNext()) {
            inline.append(scanner.nextLine());
        }
        scanner.close();

        JsonNode tokenInfo = mapper.readTree(inline.toString());

        // 사용자 정보 가져오기
        String passwd = tokenInfo.get("sub").asText();
        String email = tokenInfo.get("email").asText();
        String name = tokenInfo.get("name").asText();
        

        System.out.println("Google put() >> recive user info from google try add user");
        
        if(new LoginService().addUser(new User(email, passwd, name, email), true)) {
        	response.setStatus(HttpServletResponse.SC_OK);
        }else {
        	response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 아이디 중복
        }
    }
}
