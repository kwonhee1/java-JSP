package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import repository.FavoritesRepository;
import service.TokenService;

import java.io.IOException;

import com.fasterxml.jackson.databind.ObjectMapper;

@WebServlet("/FavoritesPage/*")
public class FavoritesController extends HttpServlet {
	// private static final long serialVersionUID = 1L;
	private FavoritesRepository repo = new FavoritesRepository();
	private TokenService tokenService = new TokenService();
	
	/// FavoritesPage return favorites json
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String userId = tokenService.getUserIdFromToken(request, response);
		
		response.setStatus(HttpServletResponse.SC_OK);
		
		ObjectMapper objectMapper = new ObjectMapper();
        String jsonResponse = objectMapper.writeValueAsString(repo.getFavoritesByUserId(userId));

        // Write JSON response
        response.getWriter().write(jsonResponse);
	}

	// FavoritesPage/gymId => add favorite
	protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		
		String userId = tokenService.getUserIdFromToken(request, response);
		if(userId.isEmpty())
			return;
		
		String action = request.getPathInfo();
		
		System.out.println("FavoritePage Put() >> action = "+action);
		if(action.isEmpty())
			return;
		
		if(repo.addFavorite(userId, Integer.valueOf(action.substring(1)))) 
			response.setStatus(HttpServletResponse.SC_OK);
	}

	// FavoritesPage/gymId => remove favorite
	protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		
		String userId = tokenService.getUserIdFromToken(request, response);
		if(userId.isEmpty())
			return;
		
		String action = request.getPathInfo();
		
		System.out.println("FavoritePage Put() >> action = "+action);
		if(action.isEmpty())
			return;
		
		if(repo.removeFavorite(userId, Integer.valueOf(action.substring(1)))) 
			response.setStatus(HttpServletResponse.SC_OK);
	}
}