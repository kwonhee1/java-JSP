package service;

import java.util.Arrays;
import java.util.NoSuchElementException;
import java.util.Optional;

import javax.crypto.SecretKey;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import repository.LoginRepository;

public class TokenService {
	private static final String SECRET_KEY = "mySuperSecretKeyThatIsAtLeast32CharactersLong"; // JWT 서명에 사용할 비밀키
	private LoginRepository loginRepository;
	public TokenService() {loginRepository = new LoginRepository(); }
	
	public User getUserFromToken(HttpServletRequest request, HttpServletResponse response) {
		User user = loginRepository.getUserById(getUserIdFromToken(request, response)); //User 검증 , User 존재시 true, 없으면 false
		return user;
	}
	
	public String getUserIdFromToken(HttpServletRequest request, HttpServletResponse response) {
		System.out.print("TokenService check() >> ");
		try {
			Optional<Cookie> token = Arrays.stream(request.getCookies()).filter(c->{return c.getName().equals("token");}).findAny();
		
			Claims claims = Jwts.parserBuilder()
					.setSigningKey(SECRET_KEY)
					.build()
					.parseClaimsJws(token.get().getValue())
					.getBody();
		
			return claims.getSubject();
		} catch(NullPointerException | NoSuchElementException e) {
			System.out.println("no token");
			return null;
		}catch(Exception e) {
			//e.printStackTrace();
			System.out.println("strange token => erase token");
			Cookie cookie = new Cookie("token", "");
			cookie.setValue(null);  // Clear cookie value
            cookie.setMaxAge(0);    // Set expiry to immediately remove it
            cookie.setPath("/");    // Ensure it matches the original path
            response.addCookie(cookie);  // Add the cookie with the modified attributes
            e.printStackTrace();
		}
		return null;
	}
	
	public static String getSecretKey() {
		return SECRET_KEY;
	}
}
