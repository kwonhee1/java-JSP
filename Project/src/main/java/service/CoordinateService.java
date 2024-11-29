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

			// CRS ��ü ����
			CRSFactory crsFactory = new CRSFactory();

			// WGS84 system ����
			//5174 epsg2097 => EPSG:2097 => EPSG:5174
			String epsg2097 = "+proj=tmerc +lat_0=38 +lon_0=127.0028902777778 +k=1 +x_0=200000 +y_0=500000 +ellps=bessel +units=m +no_defs";
	        CoordinateReferenceSystem crs5186 = crsFactory.createFromParameters("EPSG:2097", epsg2097);

	        // EPSG:3857 (Web Mercator)
	        //EPSG:4326
	        String epsg4326 = "+proj=longlat +datum=WGS84 +no_defs";
	        CoordinateReferenceSystem crs3857 = crsFactory.createFromParameters("EPSG:4326", epsg4326);

			// ��ȯ�� ��ǥ�� ���� ����
			ProjCoordinate p = new ProjCoordinate();
			p.y = Double.valueOf(y);
			p.x = Double.valueOf(x);

			// ��ȯ�� ��ǥ�� ���� ��ü ����
			ProjCoordinate p2 = new ProjCoordinate();

			CoordinateTransformFactory ctFactory = new CoordinateTransformFactory();
			// ��ȯ �ý��� ����. (���� �ý���, ��ȯ �ý���)
			CoordinateTransform coordinateTransform = ctFactory.createTransform(crs5186, crs3857);
			// ��ǥ ��ȯ
			coordinateTransform.transform(p, p2);

			// ��ȯ�� ��ǥ
			//double x = projCoordinate.x;
			//double y = projCoordinate.y;
			// System.out.println("Coordinate Service change() ("+ p.y +","+ p.x +")->("+ String.valueOf(p2.y)+","+String.valueOf(p2.x)+")");
			gym.setX(p2.x); gym.setY(p2.y);
		}catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}
}