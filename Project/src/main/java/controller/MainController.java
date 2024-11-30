package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.MapService;

import java.io.IOException;
import java.util.HashMap;

@WebServlet("/MainPage")
public class MainController extends HttpServlet {
	private static final long serialVersionUID = 1L;
private MapService mapService;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//return map.jsp
//		System.out.println("Map get() >> try to get coordinate String from repository + return map.jsp");
//		
//		request.setCharacterEncoding("UTF-8");
//		String site = request.getParameter("site");
//		
//		if(site == null) {
//			// 없으면 기본은 서울로지정
//			site = "구로구";
//		}
//		
//		String siteCode = ((HashMap<String, String>)getServletContext().getAttribute("siteCodeMap")).get(site);
//		//mapRepository = (MapRepository) getServletContext().getAttribute("mapRepository");
//		mapService = new MapService();
//		
//		request.setAttribute("gyms", mapService.getAll(siteCode));
		//request.setAttribute("baords", null);
		
		request.getRequestDispatcher("Main/FirstScreen.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
