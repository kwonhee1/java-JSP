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
            background-color: rgba(255, 255, 255, 0.4);
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
        <input type="text" id="search" /> 
        <button onclick="searchGym()">검색</button>
        <button onclick="getLocation()"> 내위치 검색</button>
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

    async function searchGym() {
        var name = document.getElementById("search").value;
        if (name == null || name < 2) {
            console.log("검색어를 2글자 이상 입력해 주세요");
            return;
        }
        fetch("<%=projectContextPath%>/MapPage?name=" + name, {
            method: 'get',
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

    async function showGym(site) {
        console.log(site);
        await fetch("<%=projectContextPath%>/MapPage?site=" + site, {
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

    async function showBoard(gymId) {
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
    
    async function saveBoardItem(button) {
        // 새로 작성된 게시글 정보 가져오기
        const boardItem = button.parentElement.parentElement.parentElement;

        // 제목, 내용, 별점, 이미지 파일 추출
        const title = boardItem.querySelector("input[type='text']").value; // 제목
        const content = boardItem.querySelector("textarea").value; // 내용
        const rate = starCount; // 별점
        const imgFile = boardItem.querySelector("input[type='file']").files[0]; // 이미지 파일
        const gymId = selected.id; // 선택된 gymId (현재 선택된 체육관의 ID)

        // 서버로 전송할 FormData 객체 생성
        const formData = new FormData();
        formData.append("title", title); // 제목
        formData.append("content", content); // 내용
        formData.append("rate", rate); // 별점
        if (imgFile == undefined) {
            formData.append("img", null); // 이미지가 없으면 null 추가
        } else {
            formData.append("img", imgFile); // 이미지 파일이 있으면 추가
        }
        formData.append("gymId", gymId); // 선택된 체육관 ID 추가

        // FormData 출력 (디버깅 용)
        for (let pair of formData.entries()) {
            console.log(pair[0] + ": " + pair[1]);
        }

        try {
            // POST 요청을 통해 새 게시글 저장
            const response = await fetch("<%=projectContextPath%>/BoardPage", {
                method: "POST",
                body: formData, // FormData 객체 전달
            });

            // 요청 성공 여부에 따른 처리
            switch (response.status) {
                case 200:
                    alert('성공');
                    showBoard(selected.id); // 새 게시글 저장 후 해당 체육관의 게시판 목록 갱신
                    break;
                case 400:
                    alert('로그인이 필요합니다');
                    boardItem.remove(); // 로그인되지 않으면 작성한 게시글을 삭제
                    break;
                default:
                    alert('알 수 없는 오류가 발생했습니다.');
                    break;
            }
        } catch (error) {
            console.error("Error saving board item:", error);
            alert("서버 요청 중 오류가 발생했습니다.");
        }
    }
    
    async function updateBoardItem(button, boardId) {
        // 수정 대상 board-item 요소 가져오기
        const boardItem = button.parentElement.parentElement.parentElement;

        // 수정된 값 가져오기
        const title = boardItem.querySelector("input[type='text']").value; // 제목
        const content = boardItem.querySelector("textarea").value; // 내용
        const rate = starCount; // 별점
        const imgFile = boardItem.querySelector("input[type='file']").files[0]; // 업로드된 이미지 파일

        // 서버에 전송할 FormData 객체 생성
        const formData = new FormData();
        formData.append("boardId", boardId);
        formData.append("title", title);
        formData.append("content", content);
        formData.append("rate", rate);
        formData.append("gymId", selected.id);
        if (imgFile) {
            formData.append("img", imgFile);
        }

        try {
            // PUT 요청을 통해 서버로 데이터 전송
            const response = await fetch("<%=projectContextPath%>/BoardPage", {
                method: "PUT",
                body: formData, // FormData를 body로 전달
            });

            // 요청 성공 여부에 따른 처리
            switch (response.status) {
                case 200:
                    alert("수정 완료");
                    showBoard(selected.id); // 수정 후 게시판 목록 다시 불러오기
                    break;
                case 400:
                    alert("수정 실패: 다시 시도해주세요.");
                    break;
                default:
                    alert("알 수 없는 오류가 발생했습니다.");
                    break;
            }
        } catch (error) {
            console.error("Error updating board item:", error);
            alert("서버 요청 중 오류가 발생했습니다.");
        }
    }
    
    async function deleteBoard(boardId) {
        try {
            // DELETE 요청을 보냄
            const response = await fetch("<%=projectContextPath%>/BoardPage/"+boardId, {
                method: 'DELETE',
            });

            // 응답 처리
            switch (response.status) {
                case 200:
                    alert("삭제 완료");
                    showBoard(selected.id); // 삭제 후 게시판 목록 갱신
                    break;
                case 404:
                    alert("작성자가 아닙니다.");
                    break;
                default:
                    alert("서버 오류가 발생했습니다.");
                    break;
            }
        } catch (error) {
            console.error("Error deleting board item:", error);
            alert("서버 요청 중 오류가 발생했습니다.");
        }
    }

    function renderBoards(boards) {
        const gymInfo = document.getElementById('gym-info');
        const boardsContainer = document.getElementById("boards");
        var rate = 0, count = 0;
        boardsContainer.innerHTML = "";

        boards.forEach(function (board) {
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
                board.content +
                "<br> <button onclick='modifyBoardItem(" + board.id + ")'>수정</button>" +
                "<button onclick='deleteBoard("+board.id+")'>삭제</button>"
            summary.addEventListener("click", function () {
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
        gymInfo.innerHTML = "<strong>" + selected.name + "</strong> <button onclick='addFavorites("+selected.id+")'>즐겨찾기</button> <div class='stars'>" + stars + "</div><hr>";
    }

    function addBoardItem(existingBoard = null) {
        const boardsContainer = document.getElementById("boards");

        const boardItem = document.createElement("div");
        boardItem.className = "board-item collapsed";

        const title = existingBoard ? existingBoard.title : "제목";
        const content = existingBoard ? existingBoard.content : "내용";
        const existingRate = existingBoard ? existingBoard.rate : 3;
        const boardId = existingBoard ? existingBoard.id : null;

        const summary = document.createElement("div");
        summary.className = "summary";
        summary.innerHTML =
            "<div id='new-stars'></div><br>" +
            "제목: <input type='text' value=" + title + " style='width: 80%;' />";

        const details = document.createElement("div");
        details.className = "details";
        details.style.display = "block";
        details.innerHTML =
            "<textarea style='width: 90%; height: 100px;'>" + content + "</textarea><br>" +
            `<label>이미지 업로드: <input type='file' accept='img'></label>`;

        const buttons = document.createElement("div");
        buttons.className = "buttons";
        var saveButton = document.createElement("button");
        saveButton.innerText = "저장";
        if (existingBoard) {
            saveButton.setAttribute("onclick", "updateBoardItem(this, " + boardId + ")");
        } else {
            saveButton.setAttribute("onclick", "saveBoardItem(this)");
        }
        buttons.appendChild(saveButton);

        details.appendChild(buttons);
        boardItem.appendChild(summary);
        boardItem.appendChild(details);

        boardsContainer.appendChild(boardItem);

        starCount = existingRate;
        createStar();
    }

    function modifyBoardItem(boardId) {
        // 기존 board 찾기
        const board = boards.find((b) => b.id === boardId);
        console.log(boardId, 'find : ', board);

        // 기존 렌더링된 board 숨기기
        const boardElement = document.getElementById("board-" + boardId);
        if (boardElement) {
            boardElement.style.display = "none"; // 숨김 처리
        }

        // 새로운 수정 인터페이스 추가
        addBoardItem(board);

        // 수정 완료 후 기존 board 다시 표시 (취소 기능 구현 가능)
        const cancelButton = document.createElement("button");
        cancelButton.innerText = "취소";
        cancelButton.onclick = function () {
            const editingBoard = document.querySelector(".board-item:not(.collapsed)");
            if (editingBoard) {
                editingBoard.remove(); // 수정 인터페이스 제거
            }
            if (boardElement) {
                boardElement.style.display = ""; // 기존 board 다시 표시
            }
        };

        // 수정 인터페이스의 버튼에 취소 버튼 추가
        const editingBoard = document.querySelector(".board-item:not(.collapsed) .buttons");
        if (editingBoard) {
            editingBoard.appendChild(cancelButton);
        }
    }


    function createStar() {
        const starContainer = document.getElementById("new-stars");
        starContainer.innerHTML = "";

        for (let i = 1; i <= 5; i++) {
            const star = document.createElement("span");
            star.className = "star";
            star.id = "star-" + i;
            star.innerHTML = "★";

            if (i <= starCount) {
                star.style.color = "gold";
            } else {
                star.style.color = "gray";
            }

            star.onclick = function () {
                starCount = i;
                createStar();
            };

            starContainer.appendChild(star);
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

    vmap.on('click', function (evt) {
        var feature = vmap.forEachFeatureAtPixel(evt.pixel, function (feature, layer) {
            if (layer != null && layer.className == 'vw.ol3.layer.Marker' && feature.values_.attr.id != undefined) {
                selected = feature.values_.attr;
                showBoard(feature.values_.attr.id);
            } else {
                return false;
            }
        });
    });

    function renderGyms(gyms) {
        markerLayer.removeAllMarker();
        gyms.forEach(function (gym) {
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
    
    function getLocation() {
        if ("geolocation" in navigator) {
          navigator.geolocation.getCurrentPosition(
            (position) => {
              const { latitude, longitude, accuracy } = position.coords;
              data = {y:latitude, x: longitude}
              getCoordinate(data)
              
            },
            (error) => {
              console.log(`위치 정보를 가져올 수 없습니다: ${error.message}`);
            },
            {
              enableHighAccuracy: true,
              timeout: 10000,    
              maximumAge: 0 
            }
          );
        } else {
          console.log("브라우저가 위치 서비스를 지원하지 않습니다.");
        }
      }
    
    async function getCoordinate(data) {
        try {
            const response = await fetch("<%=projectContextPath%>/MapPage", {
                method: 'put',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(data)
            });
            const responseData = await response.json(); 

            console.log(responseData);
            await showGym(responseData.site);

            const markerOption = {
                x: responseData.x,
                y: responseData.y,
                epsg: "EPSG:3857",
                title : responseData.text,
                contents: '',
                text: {
                    offsetX: 0.5,
                    offsetY: 20,
                    font: '12px Calibri,sans-serif',
                    fill: { color: '#fff' },
                    stroke: { color: '#000', width: 5 },
                    text:  '현위치'
                }
            };
            markerLayer.addMarker(markerOption);
            move(responseData.y, responseData.x);
        } catch (error) {
            console.error("Error deleting board item:", error);
            alert("서버 요청 중 오류가 발생했습니다.");
        }
    }


    </script>
</body>
</html>
