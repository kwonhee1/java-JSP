package controller;

import java.io.IOException;
import java.util.HashMap;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.MapService;

@WebServlet("/MapPage")
public class MapController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private MapService mapService;
	public static String site_ = "";
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//return map.jsp
		System.out.println("Map get() >> try to get coordinate String from repository + return map.jsp");
		
		request.setCharacterEncoding("UTF-8");
		String site = request.getParameter("site");
		
		
		if(site == null) {
			// 없으면 기본은 서울로지정
			site = "구로구";
		}
		
		site = ((HashMap<String, String>)getServletContext().getAttribute("siteCodeMap")).get(site);
		
		site_ = site;
		//mapRepository = (MapRepository) getServletContext().getAttribute("mapRepository");
		mapService = new MapService();
		request.setAttribute("coordinate", mapService.get(site));
		
		request.getRequestDispatcher("map.jsp").forward(request, response);
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// post 아직 없음
	}

}
