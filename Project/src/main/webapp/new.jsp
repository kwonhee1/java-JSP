<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="model.Board" %>
<%@ page import="model.Gym" %>
<% String projectContextPath = request.getContextPath(); %>

<!DOCTYPE html>
<html lang="ko">
<head>
<script type="text/javascript" src="https://map.vworld.kr/js/vworldMapInit.js.do?version=2.0&apiKey=D3ED6D88-FE33-3EA8-A41A-C9669E56C2E3"></script>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Map and Board</title>
    <style>

#map-content {
    display: flex; /* Flexbox로 좌우 배치 */
    width: 100%;
    height: 80vh; /* 화면 전체 높이 */
}

#vmap {
    width: 70%; /* 맵을 70% 차지 */
    height: 100%; /* 화면 전체 높이 */
}

#board {
    width: 30%; /* 게시판을 30% 차지 */
    height: 100%; /* 화면 전체 높이 */
    padding: 0px; /* 내용과 경계 사이 여백 */
    overflow-y: auto; /* 스크롤 기능 추가 */
    box-sizing: border-box;
}

        .board-item {
            display: flex;
            flex-direction: column;
            border-bottom: 1px solid #eee;
            margin-bottom: 10px;
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
	<div>
<select id="site" onchange="showGym(this.value)">
    <option value="구로구" selected>구로구</option>
    <option value="종로구">종로구</option>
    <option value="중구">중구</option>
    <option value="용산구">용산구</option>
    <option value="성동구">성동구</option>
    <option value="광진구">광진구</option>
    <option value="동대문구">동대문구</option>
    <option value="성북구">성북구</option>
    <option value="강북구">강북구</option>
    <option value="도봉구">도봉구</option>
    <option value="노원구">노원구</option>
    <option value="은평구">은평구</option>
    <option value="서대문구">서대문구</option>
    <option value="마포구">마포구</option>
    <option value="양천구">양천구</option>
    <option value="강서구">강서구</option>
    <option value="금천구">금천구</option>
    <option value="영등포구">영등포구</option>
    <option value="동작구">동작구</option>
    <option value="관악구">관악구</option>
    <option value="서초구">서초구</option>
    <option value="강남구">강남구</option>
    <option value="송파구">송파구</option>
    <option value="강동구">강동구</option>
</select>


	</div>
  <div id="map-content">
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
  </div>
	<script>
		var selected, boards, gyms;
        // 게시판 항목 클릭 시 펼치기/접기
        function toggleDetails(id) {
            const item = document.getElementById(id);
            item.classList.toggle("collapsed");
        }
        
     // 서버에서 boards 데이터를 가져와 렌더링하는 함수
        function showGym(site) {
    	 console.log(site);
            fetch("<%=projectContextPath%>/MapPage?site="+site, {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                }
            })
            .then(response => response.json())
            .then(data => {
            	gyms = Array.isArray(data) ? data : [data];
                console.log(data + "\n"+gyms);
                renderGyms(gyms); // gyms 데이터를 렌더링
                move(gyms[0].y, gyms[0].x);
            })
            .catch(error => {
                console.error("Error fetching gyms: ", error);
            });
        }

     // 서버에서 boards 데이터를 가져와 렌더링하는 함수
     function showBoard(gymId) {
         fetch("<%=projectContextPath%>/BoardPage/"+gymId, {
             method: 'GET',
             headers: {
                 'Content-Type': 'application/json',
             }
         })
         .then(response => response.json())
         .then(data => {
             boards = Array.isArray(data) ? data : [data]; // 데이터가 배열인지 확인 후 처리
             renderBoards(boards); // gyms 데이터를 렌더링
         })
         .catch(error => {
             console.error("Error fetching gyms: ", error);
         });
     }

     // Gyms 데이터를 기반으로 화면을 렌더링하는 함수
     function renderBoards(baords) {
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
         
         gymInfo.innerHTML = "<strong>"+selected.name+" 총합 평점: </strong>" + stars;
         
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
            initPosition: vw.ol3.CameraPosition,
            epsg: "EPSG:4326"
        };

        vmap = new vw.ol3.Map("vmap", vw.ol3.MapOptions);
        var markerLayer = new vw.ol3.layer.Marker(vmap);
        vmap.addLayer(markerLayer);
        
        vmap.on('click', function(evt) {
        	var feature = vmap.forEachFeatureAtPixel(evt.pixel, function(feature,layer) {
        		if (layer != null && layer.className == 'vw.ol3.layer.Marker') {
        			console.log(feature);
        			selected = feature.values_.attr;
        			showBoard(feature.values_.attr.id);
        	    } else {
        	    	return false;
        	    }
        	});
       	});

    function renderGyms(gyms) {
    for (let i = 0; i < gyms.length; i++) {
        const gym = gyms[i];
        console.log(gym.toString());

        const markerOption = {
            x: gym.x,
            y: gym.y,
            epsg: "EPSG:3857",
            title: gym.name,
            contents: gym.oldAddr,
            iconUrl: '//map.vworld.kr/images/ol3/marker_blue.png',
            text: {
                offsetX: 0.5,
                offsetY: 20,
                font: '12px Calibri,sans-serif',
                fill: { color: '#000' },
                stroke: { color: '#fff', width: 2 },
                text: gym.name
            },
            attr: {
                "id": gym.id,
                "name": gym.name,
                "oldAddr": gym.oldAddr,
                "newAddr": gym.newAddr
            }
        };

        markerLayer.addMarker(markerOption);
    }
}
        
        function move(y,x){
        	var _center = [x,y];
        	vmap.getView().setCenter(_center);
        	vmap.getView().setZoom(14)
        	console.log("map move ", y,x);
        }
        
        window.onload = function() {
            showGym(document.getElementById("site").value);
        };
    </script>
</body>
</html>
