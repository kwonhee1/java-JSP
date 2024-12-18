package service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import model.Gym;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.Iterator;

public class JSONService {
    public ArrayList<Gym> parseMap(InputStream inputStream, String site) {
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
    
    public String getSiteName(InputStream inputStream) {
    	try {
    		// ObjectMapper를 사용하여 JSON 파싱
            ObjectMapper objectMapper = new ObjectMapper();
            
            // JSON을 트리 구조로 파싱
            JsonNode rootNode = objectMapper.readTree(inputStream);
            
//            // "response" -> "result" -> 첫 번째 항목 -> "structure" -> "level2"에서 "중구"를 추출
//            JsonNode level2Node = rootNode.path("response")
//                                          .path("result")
//                                          .get(0)  // 첫 번째 요소
//                                          .path("structure")
//                                          .path("level2");
            
            JsonNode resultNode = rootNode.path("response").path("result").get(0);
            JsonNode structureNode = resultNode.path("structure");
            String level2 = structureNode.path("level2").asText();  // "구로구"
            String text = resultNode.path("text").asText();  // "서울특별시 구로구 구로동 64"
            
            // "level2" 값 반환
            return String.format("\"site\" : \"%s\", \"text\":\"%s\"", level2, text);
    	}catch (Exception e) {
    		e.printStackTrace();
			return null;
		}
    }
}