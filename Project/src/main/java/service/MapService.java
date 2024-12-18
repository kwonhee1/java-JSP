package service;

import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;

import model.Gym;
import repository.MapRepository;
import repository.Repository;

public class MapService {
	private JSONService jsonService;
	
	public MapService() {
		jsonService = new JSONService();
	}
	
	public ArrayList<Gym> getAll(String siteCode) {
		return new MapRepository().getAvaliableGyms(siteCode);
	}
	
	public void updateAll(HashMap<String, String> siteMap) {
		MapRepository repository = new MapRepository();
		siteMap.values().forEach(s->{
			ArrayList<Gym> lists = jsonService.parseMap(getConnection(s), s);
			repository.updateAll(lists);
		});
	}
	
	public void reload(HashMap<String, String> siteMap) {
		MapRepository repository = new MapRepository();
		repository.deleteAll();
		siteMap.values().forEach(s->{
			ArrayList<Gym> lists = jsonService.parseMap(getConnection(s), s);
			repository.save(lists);
		});
	}
	
	public String getSiteName(String y, String x) {
		try {
		URL url = new URL( String.format("https://api.vworld.kr/req/address?service=address&request=getAddress&version=2.0&crs=epsg:4326&point=%s,%s&format=json&type=PARCEL&zipcode=false&simple=true&key=D3ED6D88-FE33-3EA8-A41A-C9669E56C2E3", x,y));
		System.out.println("MapService get api url : "+ String.format("https://api.vworld.kr/req/address?service=address&request=getAddress&version=2.0&crs=epsg:4326&point=%s,%s&format=json&type=PARCEL&zipcode=false&simple=true&key=D3ED6D88-FE33-3EA8-A41A-C9669E56C2E3", x,y));
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("GET");
		conn.setRequestProperty("Content-type", "application/json");
		
		return jsonService.getSiteName(conn.getInputStream());
		}catch (Exception e) {
			return null;
		}
		}
	
	private InputStream getConnection(String siteCode) {
		
		try {
		URL url = new URL(String.format("http://openapi.seoul.go.kr:8088/674e4358466c6b6837304941454e54/json/LOCALDATA_104201_%s/1/1000", siteCode));
		System.out.println("MapRepository url:"+url);
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("GET");
		conn.setRequestProperty("Content-type", "application/json");
		System.out.println("Response code: " + conn.getResponseCode()); /* 연결 자체에 대한 확인이 필요하므로 추가합니다.*/
		
		if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
			return conn.getInputStream();
		}else
			return null;
		}catch(Exception e) {
			e.printStackTrace();
			return null;
		}
	}
}
