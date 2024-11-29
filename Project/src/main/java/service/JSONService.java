package service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import model.Gym;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.Iterator;

public class JSONService {
    public ArrayList<Gym> parseJson(InputStream inputStream, String site) {
    	try {
        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode rootNode = objectMapper.readTree(inputStream);

        // 최상위 키 동적으로 추출
        Iterator<String> fieldNames = rootNode.fieldNames();
        if (fieldNames.hasNext()) {
            String topLevelKey = fieldNames.next(); // 최상위 키 가져오기
            System.out.println("JSONSercvice parseJson() >> topLevelKey : "+ topLevelKey);
            JsonNode rowNode = rootNode.path(topLevelKey).path("row");

            ArrayList<Gym> arrayList = new ArrayList<Gym>();
            
            rowNode.forEach(node->{
            	Gym gym;
            	if(node.path("TRDSTATEGBN").asText().equals("01") && !node.path("X").asText().equals("")) {
            		gym = new Gym(site, node.path("SITEWHLADDR").asText()
            				,node.path("RDNWHLADDR").asText(), node.path("BPLCNM").asText(), node.path("TRDSTATEGBN").asText().equals("01"));
            		CoordinateService.change(node.path("Y").asText(),node.path("X").asText(), gym);
            		//System.out.println(gym.toString());
            		arrayList.add(gym);
            	}
            });
            System.out.println(arrayList.get(1).toString());
            return arrayList;
        }
    	}catch(Exception e) {
    		e.printStackTrace();
    	}
    	return null;
    }
}