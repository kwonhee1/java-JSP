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

        .summary .stars {
            color: gold;
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
        var selected, boards, gyms;

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
                console.log(data + "\n" + gyms);
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
                    "<span>" + board.title + "</span> - 작성자: " + board.userName +
                    " <span class='created-at'>(" + board.createdAt + ")</span>" +
                    " <span class='stars'>" + stars + "</span>";

                const details = document.createElement("div");
                details.className = "details";
                details.style.display = "none";
                details.innerHTML =
                    "<p>" + board.content + "</p>" +
                    "<div>" +
                    (board.imgURI ? "<img src='<%=projectContextPath%>/images/" + board.imgURI + "' alt='이미지'>" : "이미지 없음") +
                    "</div>" +
                    "<button onclick='editBoardItem(" + board.id + ")'>수정</button>" +
                    "<button onclick='deleteBoardItem(" + board.id + ")'>삭제</button>";

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

            gymInfo.innerHTML = "<strong>" + selected.name +"</strong>"+ stars;
        }

        function editBoardItem(boardId) {
            alert(`Gym ID ${boardId} 수정 기능은 구현 필요.`);
        }

        function deleteBoardItem(boardId) {
            alert(`Gym ID ${boardId} 삭제 기능은 구현 필요.`);
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
