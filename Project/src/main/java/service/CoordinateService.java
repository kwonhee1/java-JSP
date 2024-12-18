package service;

import org.locationtech.proj4j.CRSFactory;
import org.locationtech.proj4j.CoordinateReferenceSystem;
import org.locationtech.proj4j.CoordinateTransform;
import org.locationtech.proj4j.CoordinateTransformFactory;
import org.locationtech.proj4j.ProjCoordinate;

import model.Gym;

public class CoordinateService {
	
	static public String change(String y, String x, Gym gym) {
		try {

			// CRS 객체 생성
			CRSFactory crsFactory = new CRSFactory();

			// WGS84 system 정의
			//5174 epsg2097 => EPSG:2097 => EPSG:5174
			String epsg2097 = "+proj=tmerc +lat_0=38 +lon_0=127.0028902777778 +k=1 +x_0=200000 +y_0=500000 +ellps=bessel +units=m +no_defs";
	        CoordinateReferenceSystem crs5186 = crsFactory.createFromParameters("EPSG:2097", epsg2097);

	        // EPSG:3857 (Web Mercator)
	        //EPSG:4326 => 3857로 설정 변경
	        String epsg4326 = "+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext +no_defs";
	        CoordinateReferenceSystem crs3857 = crsFactory.createFromParameters("EPSG:4326", epsg4326);

			// 변환할 좌표계 정보 생성
			ProjCoordinate p = new ProjCoordinate();
			p.y = Double.valueOf(y);
			p.x = Double.valueOf(x);

			// 변환된 좌표를 담을 객체 생성
			ProjCoordinate p2 = new ProjCoordinate();

			CoordinateTransformFactory ctFactory = new CoordinateTransformFactory();
			// 변환 시스템 지정. (원본 시스템, 변환 시스템)
			CoordinateTransform coordinateTransform = ctFactory.createTransform(crs5186, crs3857);
			// 좌표 변환
			coordinateTransform.transform(p, p2);

			// 변환된 좌표
			//double x = projCoordinate.x;
			//double y = projCoordinate.y;
			// System.out.println("Coordinate Service change() ("+ p.y +","+ p.x +")->("+ String.valueOf(p2.y)+","+String.valueOf(p2.x)+")");
			gym.setX(p2.x); gym.setY(p2.y);
		}catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}
	
	static public String changeFrom(String y, String x) {
		try {
			// CRS 객체 생성
			CRSFactory crsFactory = new CRSFactory();

			String epsg4326 = "+proj=longlat +datum=WGS84 +no_defs";
	        CoordinateReferenceSystem crs4326 = crsFactory.createFromParameters("EPSG:2097", epsg4326);

	        String epsg3857 = "+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext +no_defs";
	        CoordinateReferenceSystem crs3857 = crsFactory.createFromParameters("EPSG:4326", epsg3857);

			// 변환할 좌표계 정보 생성
			ProjCoordinate p = new ProjCoordinate();
			p.y = Double.valueOf(y);
			p.x = Double.valueOf(x);

			// 변환된 좌표를 담을 객체 생성
			ProjCoordinate p2 = new ProjCoordinate();

			CoordinateTransformFactory ctFactory = new CoordinateTransformFactory();
			// 변환 시스템 지정. (원본 시스템, 변환 시스템)
			CoordinateTransform coordinateTransform = ctFactory.createTransform(crs4326, crs3857);
			// 좌표 변환
			coordinateTransform.transform(p, p2);

			// 변환된 좌표
			System.out.println(String.format("input (y, x) = (%s, %s), output = (%f,%f)", y,x,p2.y,p2.x).toString());
			
			return String.format("\"y\": %.10f, \"x\": %.10f", p2.y, p2.x);
		}catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}