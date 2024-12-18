package controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.http.HttpRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Gym;
import repository.BoardRepository;
import repository.MapRepository;
import service.BoardService;
import service.CoordinateService;
import service.MapService;

@WebServlet("/MapPage")
public class MapController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	// Map 정보르 반환해줌
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String site = request.getParameter("site");
		String name = request.getParameter("name");
		
		ArrayList<Gym> gyms = null;
		
		if(name != null && name.length() >=2 ) {
			gyms = doSearch(request, response, name);
		}else {
			System.out.println("MapPage >> doGet() >> input siteCode ="+site+", return avaliable map datas as json");
			if(site == null) {
			// 없으면 기본은 서울로지정
				site = "구로구";
			}
			String siteCode = ((HashMap<String, String>)getServletContext().getAttribute("siteCodeMap")).get(site);
			//mapRepository = (MapRepository) getServletContext().getAttribute("mapRepository");
			gyms = new MapService().getAll(siteCode);
		}
		
		ObjectMapper objectMapper = new ObjectMapper();
        String jsonResponse = objectMapper.writeValueAsString(gyms);

        // Write JSON response
        response.getWriter().write(jsonResponse);
        return ;
	}
	 
	 protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		 String input = request.getReader().readLine();
		 
		 String regex = "\\{\"y\"\\s*:\\s*(.*?),\\s*\"x\"\\s*:\\s*(.*?)\\s*\\}";
		 System.out.println("Map Page >> Put >> chage coordinate " + input);
	     String output = "{%s, %s}";
	        // 패턴 컴파일
	     Pattern pattern = Pattern.compile(regex);
	     Matcher matcher = pattern.matcher(input);   
	      
	     matcher.find();
	     String y = matcher.group(1);
	     String x = matcher.group(2);
	     
	     String coord = CoordinateService.changeFrom(y,x);
	     String site = (new MapService()).getSiteName(y, x);
	     
	     System.out.println("Map Page >> Put >> output " + String.format(output, coord, site));
	     
	     response.setStatus(HttpServletResponse.SC_OK);
	     response.getWriter().write(String.format(output, coord, site));
	     return;
	 }
	 
	 // map page search with gym name (String)
	 private ArrayList<Gym> doSearch(HttpServletRequest request, HttpServletResponse response, String name) throws ServletException, IOException{
		 System.out.println("MapPage >> get >> search >> input name : "+name+", return gyms datas as json where name = name");
		 ArrayList<Gym> gyms = new MapRepository().getGymsWithName(name);
		 
		 if(gyms == null) {
			 response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			 return null;
		 }else {
			 response.setStatus(HttpServletResponse.SC_OK);
		     return gyms;
		 }
	 }
}
