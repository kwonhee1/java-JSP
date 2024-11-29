<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="model.Board" %>
<%@ page import="model.Gym" %>
<% String projectContextPath = request.getContextPath(); %>
<%
    List<Board> boards = (List<Board>)request.getAttribute("boards");
    List<Gym> gyms = (List<Gym>)request.getAttribute("gyms");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<script type="text/javascript" src="https://map.vworld.kr/js/vworldMapInit.js.do?version=2.0&apiKey=D3ED6D88-FE33-3EA8-A41A-C9669E56C2E3"></script>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Map and Board</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: grid;
            grid-template-columns: 2fr 1fr;
            grid-gap: 10px;
            height: 100vh;
        }
        #board {
            padding: 10px;
            border: 1px solid #ccc;
            overflow-y: auto;
        }
        .board-item {
            display: flex;
            flex-direction: column;
            border-bottom: 1px solid #eee;
            margin-bottom: 10px;
            padding-bottom: 10px;
            cursor: pointer;
        }
        .board-item.collapsed .details {
            display: none;
        }
        .board-item .summary {
            font-weight: bold;
        }
        .board-item img {
            width: 100px;
            height: 100px;
            object-fit: cover;
        }
        .rating {
            color: #f39c12;
        }
        .buttons {
            margin-top: 5px;
        }
        .buttons button {
            margin-right: 5px;
        }
        .gym-info {
            margin-top: 20px;
        }
        .gym-info strong {
            font-size: 1.2em;
        }
        .summary .stars {
    		color: gold; /* 별표 색상 */
    		font-size: 14px; /* 별표 크기 */
    		margin-left: 10px; /* 여백 */
		}
        
    </style>
</head>
<body>

    <!-- 지도 -->
    <div id="vmap"></div>

    <!-- 게시판 -->
    <div id="board">
        <h2>게시판</h2>
        <div id="gym-info">
           
        </div> 
        
        <!-- Gym 정보 표시 -->
        <div id="boards"></div>
        <button onclick="addBoardItem()">게시판 추가</button> 
    </div>
	<script>
		var selected;
        // 게시판 항목 클릭 시 펼치기/접기
        function toggleDetails(id) {
            const item = document.getElementById(id);
            item.classList.toggle("collapsed");
        }

        let gyms = []; // 서버에서 받아온 gyms 데이터가 저장될 배열

     // 서버에서 gyms 데이터를 가져와 렌더링하는 함수
     function showGym(gymId) {
         fetch("<%=projectContextPath%>/BoardPage/"+gymId, {
             method: 'GET',
             headers: {
                 'Content-Type': 'application/json',
             }
         })
         .then(response => response.json())
         .then(data => {
             boards = Array.isArray(data) ? data : [data]; // 데이터가 배열인지 확인 후 처리
             console.log(data + "\n"+boards);
             renderGyms(boards); // gyms 데이터를 렌더링
         })
         .catch(error => {
             console.error("Error fetching gyms: ", error);
         });
     }

     // Gyms 데이터를 기반으로 화면을 렌더링하는 함수
     function renderGyms(baords) {
         // 2. 게시판에 항목 추가
         const gymInfo = document.getElementById('gym-info');
         const boardsContainer = document.getElementById("boards");
         var rate = 0, count = 0;
         boardsContainer.innerHTML = ""; // 기존 내용을 초기화

         // 각 게시판 항목 생성
         boards.forEach(function(board) {
        	 count++; rate+= board.rate;
        	 
             // 게시판 아이템 요소 생성
             const boardItem = document.createElement("div");
             boardItem.className = "board-item collapsed"; // 초기 상태는 접힘 상태
             boardItem.id = "board-" + board.id;
			
             // 요약 정보
             const summary = document.createElement("div");
             let stars = "";
             for (let i = 0; i < board.rate; i++) {
                 stars += "★"; // 별표를 누적
             }
             summary.className = "summary";
             summary.innerHTML = 
                 "<span>" + board.title + "</span> - 작성자: " + board.userName + 
                 " <span class='created-at'>(" + board.createdAt + ")</span>" +
                 " <span class='stars'>" + stars + "</span>";

             // 세부 정보
             const details = document.createElement("div");
             details.className = "details";
             details.style.display = "none"; // 초기 상태는 숨김
             details.innerHTML = 
                 "<p>" + board.content + "</p>" +
                 "<div>" +
                 (board.imgURI ? "<img src='<%=projectContextPath%>/images/"+ board.imgURI + "' alt='이미지'>" : "이미지 없음") +
                 "</div>" +
                 "<button onclick='editBoardItem(" + board.id + ")'>수정</button>" +
                 "<button onclick='deleteBoardItem(" + board.id + ")'>삭제</button>";

             // 클릭 이벤트로 세부 정보 표시/숨김 처리
             summary.addEventListener("click", function() {
                 const isCollapsed = boardItem.classList.contains("collapsed");
                 boardItem.classList.toggle("collapsed");
                 details.style.display = isCollapsed ? "block" : "none";
             });

             // 각 요소를 boardItem에 추가
             boardItem.appendChild(summary);
             boardItem.appendChild(details);

             // boardsContainer에 추가
             boardsContainer.appendChild(boardItem);
         });

         // Gym 정보 표시
         let stars = "";
         for (let i = 0; i < rate/count; i++) {
             stars += "★"; // 별표를 누적
         }
         
         gymInfo.innerHTML = "<strong>"+selected.name+"</strong><p>구주소 : "+selected.oldAddr+"<br/>도로명 주소 : "+selected.newAddr+"</p>"+
         	"<strong>총합 평점: </strong>" + stars;
         
     }

     // 수정 버튼 클릭 시 호출되는 함수
     function editBoardItem(boardId) {
         alert(`Gym ID ${gymId} 수정 기능은 구현 필요.`);
     }

     // 삭제 버튼 클릭 시 호출되는 함수
     function deleteBoardItem(boardId) {
         alert(`Gym ID ${gymId} 삭제 기능은 구현 필요.`);
     }
     
     function createGymItem(gymId){
    	 
     }
     
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
        
        vmap.on('click', function(evt) {
        	var feature = vmap.forEachFeatureAtPixel(evt.pixel, function(feature,layer) {
        		if (layer != null && layer.className == 'vw.ol3.layer.Marker') {
        			console.log(feature);
        			selected = feature.values_.attr;
        			showGym(feature.values_.attr.id);
        	    } else {
        	    	return false;
        	    }
        	});
       	});

        <% for (int i = 0; i < gyms.size(); i++) { 
            Gym gym = gyms.get(i);
        %>
        	console.log("<%= gym.toString() %>");
            vw.ol3.markerOption = {
                x: <%= gym.getX() %>,
                y: <%= gym.getY() %>,
                epsg: "EPSG:4326",
                title: "<%= gym.getName() %>",
                contents: "<%= gym.getOldAddr() %>",
                iconUrl: '//map.vworld.kr/images/ol3/marker_blue.png',
				text: {
                    offsetX: 0.5,
                    offsetY: 20,
                    font: '12px Calibri,sans-serif',
                    fill: { color: '#000' },
                    stroke: { color: '#fff', width: 2 },
                    text: "<%= gym.getName() %>"
                },
                attr: { "id": "<%= gym.getId() %>", "name": "<%= gym.getName() %>", "oldAddr":"<%=gym.getOldAddr() %>", "newAddr":"<%=gym.getNewAddr()%>" }
            };
            markerLayer.addMarker(vw.ol3.markerOption);
        <% } %>
    </script>
</body>
</html>
