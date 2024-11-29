package servletcontentlistener;

import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import service.CoordinateService;

@WebListener
public class MainListener implements ServletContextListener {

    
    public MainListener() {
        // TODO Auto-generated constructor stub
    }
    
    public void contextDestroyed(ServletContextEvent sce)  {
    	
    }

    
    public void contextInitialized(ServletContextEvent sce)  { 
        // 서버가 시작 할때
    	
    	//Class.forName()
    	try {	
			Class.forName("com.mysql.cj.jdbc.Driver");	
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.out.println("MainListener >> contextInitilized() >> Class.forNmae() >>fail cannot get jdbc dirver ");
		}
    
    	// siteCode Map
    	Map<String, String> siteCodeMap = new HashMap<String, String>();
    	siteCodeMap.put("종로구", "JR");
    	siteCodeMap.put("중구", "JG");
    	siteCodeMap.put("용산구", "YS");
    	siteCodeMap.put("성동구", "SD");
    	siteCodeMap.put("광진구", "GJ");
    	siteCodeMap.put("동대문구", "DD");
    	siteCodeMap.put("종로구", "JN");
    	siteCodeMap.put("성북구", "SB");
    	siteCodeMap.put("강북구", "GB");
    	siteCodeMap.put("도봉구", "DB");
    	siteCodeMap.put("노원구", "NW");
    	siteCodeMap.put("은평구", "EP");
    	siteCodeMap.put("서대문구", "SM");
    	siteCodeMap.put("마포구", "MP");
    	siteCodeMap.put("양천구", "YC");
    	siteCodeMap.put("강서구", "GS");
    	siteCodeMap.put("구로구", "GR");
    	siteCodeMap.put("금천구", "GC");
    	siteCodeMap.put("영등포구", "YD"); 
    	siteCodeMap.put("동작구", "DJ");
    	siteCodeMap.put("관악구", "GA");
    	siteCodeMap.put("서초구", "SC");
    	siteCodeMap.put("강남구", "GN");
    	siteCodeMap.put("송파구", "SP");
    	siteCodeMap.put("강동구", "GD");
    	sce.getServletContext().setAttribute("siteCodeMap", siteCodeMap);
    	
    	new CoordinateService();
    	
    	String imgURL = sce.getServletContext().getRealPath("/").split("\\.")[0] + "Project\\src\\main\\webapp\\images\\";
    	sce.getServletContext().setAttribute("imgURL", imgURL);
    }
}
