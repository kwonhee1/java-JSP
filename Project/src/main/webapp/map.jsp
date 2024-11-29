<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Map Visualization</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
        }
        #vmap {
            width: 100%;
            height: 350px;
            border: 1px solid #ccc; /* 추가된 스타일 */
        }
    </style>
    <script type="text/javascript" src="https://map.vworld.kr/js/vworldMapInit.js.do?version=2.0&apiKey=D3ED6D88-FE33-3EA8-A41A-C9669E56C2E3"></script>

</head>
<body>

    <h1>Map Visualization</h1>
    <div id="vmap"></div>

    <script>
    	var coordinate = <%= request.getAttribute("coordinate") %>; // JSP에서 jsonData 속성 사용
    	console.log(coordinate);
    	console.log(coordinate[1].x)
        var vmap;

        vw.ol3.MapOptions = {
            basemapType: vw.ol3.BasemapType.GRAPHIC,
            controlDensity: vw.ol3.DensityType.EMPTY,
            interactionDensity: vw.ol3.DensityType.BASIC,
            controlsAutoArrange: true,
            homePosition: vw.ol3.CameraPosition,
            initPosition: vw.ol3.CameraPosition
        };

        vmap = new vw.ol3.Map("vmap", vw.ol3.MapOptions);
        var markerLayer = new vw.ol3.layer.Marker(vmap);
        vmap.addLayer(markerLayer);
        for(co of coordinate){
        	vw.ol3.markerOption = {
        		    x : co.x ,
        		    y : co.y ,
        		    epsg : "EPSG:4326",
        		    title : co.name,
        		    contents : co.site,
        		    iconUrl : '//map.vworld.kr/images/ol3/marker_blue.png',
        		  text : {
        		    offsetX: 0.5, //위치설정
        		    offsetY: 20,   //위치설정
        		    font: '12px Calibri,sans-serif',
        		    fill: {color: '#000'},
        		    stroke: {color: '#fff', width: 2},
        		    text: co.name
        		  },
        		  attr: {"id":"maker01","name":"속성명1"}  
        		   };
            markerLayer.addMarker(vw.ol3.markerOption);
        }
        
    </script>

</body>
</html>
