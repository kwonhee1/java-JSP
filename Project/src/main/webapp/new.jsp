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
            display: flex;
            width: 100%;
            height: 80vh;
        }

        #vmap {
            width: 70%;
            height: 100%;
        }

        #board {
            width: 30%;
            height: 100%;
            padding: 0;
            overflow-y: auto;
            box-sizing: border-box;
            background-color: rgb(255, 255, 255, 0.4);
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

        .stars {
            color: red;
            font-size: 14px;
            margin-left: 10px;
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
            <div id="gym-info"></div>
            <div id="boards"></div>
            <button onclick="addBoardItem()">게시판 추가</button>
        </div>
    </div>

    <script>
        var selected, boards, gyms, starCount = 0;

        function toggleDetails(id) {
            const item = document.getElementById(id);
            item.classList.toggle("collapsed");
        }

        function showGym(site) {
            console.log(site);
            fetch("<%=projectContextPath%>/MapPage?site=" + site, {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                }
            })
            .then(response => response.json())
            .then(data => {
                gyms = Array.isArray(data) ? data : [data];
                renderGyms(gyms);
                move(gyms[0].y, gyms[0].x);
            })
            .catch(error => {
                console.error("Error fetching gyms: ", error);
            });
        }

        function showBoard(gymId) {
            fetch("<%=projectContextPath%>/BoardPage/" + gymId, {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                }
            })
            .then(response => response.json())
            .then(data => {
                boards = Array.isArray(data) ? data : [data];
                renderBoards(boards);
            })
            .catch(error => {
                console.error("Error fetching gyms: ", error);
            });
        }

        function renderBoards(boards) {
            const gymInfo = document.getElementById('gym-info');
            const boardsContainer = document.getElementById("boards");
            var rate = 0, count = 0;
            boardsContainer.innerHTML = "";

            boards.forEach(function(board) {
                count++;
                rate += board.rate;

                const boardItem = document.createElement("div");
                boardItem.className = "board-item collapsed";
                boardItem.id = "board-" + board.id;

                const summary = document.createElement("div");
                let stars = "";
                for (let i = 0; i < board.rate; i++) {
                    stars += "★";
                }
                summary.className = "summary";
                summary.innerHTML =
                    "작성자: " + board.userName + 
                    "<img src='<%=projectContextPath%>/images/" + board.userImgURI + "' alt='user img' style='width: 30px; height: 30px;' /> " +
                    "<span class='stars'>" + stars + "</span><br>" +
                    "제목 : " + board.title + " ( " + board.createdAt + " )";


                const details = document.createElement("div");
                details.className = "details";
                details.style.display = "none";
                details.innerHTML =
                    "<img src='<%=projectContextPath%>/images/" + board.imgURI + "' alt='이미지' style='width: 200px; height: 150px;'> <br>" +
                    board.content
                summary.addEventListener("click", function() {
                    const isCollapsed = boardItem.classList.contains("collapsed");
                    boardItem.classList.toggle("collapsed");
                    details.style.display = isCollapsed ? "block" : "none";
                });

                boardItem.appendChild(summary);
                boardItem.appendChild(details);
                boardsContainer.appendChild(boardItem);
            });

            let stars = "";
            for (let i = 0; i < rate / count; i++) {
                stars += "★";
            }

            gymInfo.innerHTML = "<strong>" + selected.name +"</strong> <div class='stars'>"+ stars +"</div><hr>";
        }

        function addBoardItem() {
            const boardsContainer = document.getElementById("boards");

            // Create a new board item
            const boardItem = document.createElement("div");
            boardItem.className = "board-item collapsed";

            // Create the summary section
            const summary = document.createElement("div");
            summary.className = "summary";
            summary.innerHTML =
                "<div id='new-stars'></div><br>" +
                "제목: <input type='text' placeholder='제목 입력' style='width: 80%;' />";

            // Create the details section
            const details = document.createElement("div");
            details.className = "details";
            details.style.display = "block";
            details.innerHTML =
                "<textarea placeholder='내용을 입력하세요' style='width: 90%; height: 100px;'></textarea><br>" +
                "<label>이미지 업로드: <input type='file' accept='img'></label>";

            // Add buttons for saving or canceling
            const buttons = document.createElement("div");
            buttons.className = "buttons";
            buttons.innerHTML =
                "<button onclick='saveBoardItem(this)'>저장</button>" +
                "<button onclick='this.parentElement.parentElement.parentElement.remove()'>취소</button>";

            // Append sections to the board item
            details.appendChild(buttons);
            boardItem.appendChild(summary);
            boardItem.appendChild(details);

            // Append the new board item to the boards container
            boardsContainer.appendChild(boardItem);
            
            starCount = 3;
            createStar();
        }
        function createStar() {
            // Clear the previous stars
            const starContainer = document.getElementById("new-stars");
            starContainer.innerHTML = "";

            // Create the filled stars (based on the current starCount)
            for (let i = 1; i <= 5; i++) {
                const star = document.createElement("span");
                star.className = "star"; // Add a CSS class for styling
                star.id = "star-" + i; // Unique ID for each star
                star.innerHTML = "★"; // Star symbol

                // Set the color of the star based on whether it is selected
                if (i <= starCount) {
                    star.style.color = "gold"; // Filled star
                } else {
                    star.style.color = "gray"; // Empty star
                }

                // Add the click event to update the starCount
                star.onclick = function() {
                    starCount = i;
                    createStar(); // Recreate the stars with the new starCount
                };

                starContainer.appendChild(star); // Append the star to the container
            }
        }

        async function saveBoardItem(button) {
            const boardItem = button.parentElement.parentElement.parentElement;

            const title = boardItem.querySelector("input[placeholder='제목 입력']").value;
            const content = boardItem.querySelector("textarea").value;
            const rate = starCount;
            const imgFile = boardItem.querySelector("input[type='file']").files[0];
            const gymId = selected.id;
            
            // FormData 생성
            const formData = new FormData();
            formData.append("title", title);
            formData.append("content", content);
            formData.append("rate", rate);
            if(imgFile == undefined)
            	formData.append("img", null);
            else
            	formData.append("img", imgFile);
            formData.append("gymId", gymId);
            
            for (let pair of formData.entries()) {
                console.log(pair[0] + ": " + pair[1]);
            }

            const response = await fetch("<%=projectContextPath%>/BoardPage", {
                method: "POST",
                body: formData, // FormData를 body로 전달
            });
            switch(response.status){
            case 200:
            	alert('성공');
            	break;
            case 400:
            	alert('로그인이 필요합니다');
            	boardItem.remove();
            	break;
            }
        }


        function deleteBoardItem(boardItem) {
        	boardItem.remove();
        }

        vw.ol3.MapOptions = {
            basemapType: vw.ol3.BasemapType.GRAPHIC,
            controlDensity: vw.ol3.DensityType.EMPTY,
            interactionDensity: vw.ol3.DensityType.BASIC,
            controlsAutoArrange: true,
            homePosition: vw.ol3.CameraPosition,
            initPosition: vw.ol3.CameraPosition,
            epsg: "EPSG:4326"
        };

        var vmap = new vw.ol3.Map("vmap", vw.ol3.MapOptions);
        var markerLayer = new vw.ol3.layer.Marker(vmap);
        vmap.addLayer(markerLayer);

        vmap.on('click', function(evt) {
            var feature = vmap.forEachFeatureAtPixel(evt.pixel, function(feature, layer) {
                if (layer != null && layer.className == 'vw.ol3.layer.Marker') {
                    selected = feature.values_.attr;
                    showBoard(feature.values_.attr.id);
                } else {
                    return false;
                }
            });
        });

        function renderGyms(gyms) {
            gyms.forEach(function(gym) {
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
            });
        }

        function move(y, x) {
            var _center = [x, y];
            vmap.getView().setCenter(_center);
            vmap.getView().setZoom(14);
            console.log("map move ", y, x);
        }

        window.onload = function() {
            showGym(document.getElementById("site").value);
        };
    </script>
</body>
</html>
