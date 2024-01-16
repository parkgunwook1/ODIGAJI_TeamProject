<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="odi_project.chat.model.vo.Chat, odi_project.chat.model.vo.ChatRoom, java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
	List<Chat> chatList = (List<Chat>) session.getAttribute("chatList");
// 	List<Message> msgList = (List<Message>) session.getAttribute("msgList");

// Add more properties as needed
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- 파비콘 -->
<link rel="shortcut icon" href="./images/tomorrow1.gif">
<title>Odigaji</title>

<!--브라우저 스타일 초기화-->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/reset-css@5.0.1/reset.min.css" />
<link
	href="https://fonts.googleapis.com/css2?family=Nanum+Gothic:wght@400;700&display=swap"
	rel="stylesheet" />
<!--Google Material Icons-->
<link rel="stylesheet"
	href="https://fonts.googleapis.com/icon?family=Material+Icons" />
<!-- sidebar open/close Icon -->
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
<!-- login icon -->
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
<!-- my page icon -->
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
<!-- heart icon -->
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
<!-- chat icon -->
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
<!-- chat group icon -->
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />

<!-- css -->
<link rel="stylesheet"
	href="./source/style/css/ejun.css/liveChatRoom.css">
<!-- jquery -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<style>
/* 채팅 메시지 컨테이너 */
</style>
<body>
	<!--HEADER-->
	<jsp:include page="../common/header.jsp" />

	<!--LEFT SIDEBAR 채팅창-->
	<div class="inner">
		<div class="left-sidebar"></div>
	</div>

	<!-- main chat 채팅방 목록 -->

	<div class="inner"></div>
	<div class="page-name">실시간 채팅</div>

	<div class="outer">
		<div class='msgOuter'>
			<!-- <br> <h1 align="center">채팅</h1> <br>
 -->
			<div class="msgContainer">
				<div class="msgReceive">
					<c:forEach var="msgList" items="${msgList}">
						<p class="RmemberId">${msgList.memberId} 님 : </p> 
						<p class="Rcontent">${msgList.content}</p> <br>
					</c:forEach>
				</div>
				<div id="msgListContainer"></div>
			</div>
			<div class="buttonContainer">
				<input type='hidden' name="chatKey" id="chatKey" value='${chatKey}'>
				<input type='hidden' name="memberId" id="sender" size="10"
					value="${loginUser.memberId}">
					 <input type="text" id="msg" placeholder="전송할 메세지" onkeypress="handleKeyPress(event)">
				<button onclick="sendMsg()" type="submit">전송</button>
			</div>
		</div>
	</div>


	<script>
		// 웹소켓 서버에 연결하기
		// WebSocket객체 생성하기  192.168.30.169 //cmd 창에 ipconfig 치면 나옴

		const socketAddress = "ws://192.168.30.169:8087<%=request.getContextPath()%>/chatting.do"; 
		let socket = new WebSocket(socketAddress);
		socket.onopen = function(e){
			console.log("웹 소켓 접속 성공");
		}
		
		/* var msgContainer = document.getElementById("msgContainer");
		msgContainer.scrollTop = msgContainer.scrollHeight; */
		
		// 스크롤을 항상 아래로 이동하는 함수 추가
		function scrollDown() {
	        var container = $("#msgListContainer"); // 수정된 컨테이너 ID
	        container.scrollTop(container[0].scrollHeight);
	    }
		socket.onmessage = function(e){
			console.log('메세지 수신됨' , e);
			
			const msg = JSON.parse(e.data); //jsonobject로 전달된 메세지 파싱
			if(msg["memberId"] == '${loginUser.memberId}'){
				$("#msgListContainer").append($("<p>").text(msg["memberId"]+" 님 : " + msg["content"]).css("text-align","right").css("margin","10px"))
			}else{
				$("#msgListContainer").append($("<p>").text(msg["memberId"]+" 님 : " + msg["content"]).css("text-align","left"))
			}
			  // 스크롤을 항상 아래로 이동
			  scrollDown();
		}
		
		socket.onclose = function(e){
			setTimeout(function(){
				socket = new WebSocket(socketAddress);
			}, 1000);
		}
		const sendMsg = () => {
		    const msg = {
		        content: $("#msg").val(),
		        memberId: '${loginUser.memberId}',
		        chatKey: '${chatKey}'
		    }
		    socket.send(JSON.stringify(msg));

		    // 메시지 전송 후에 스크롤 항상 아래로 이동
		    scrollDown();
		};
		
		// 엔터 키를 눌렀을 때 sendMsg 함수 호출
	    function handleKeyPress(event) {
	        if (event.keyCode === 13) {
	            sendMsg();
	            //초기화
	            $("#msg").val('');
	        }
	        
	    }

		
	</script>


	<!--FOOTER -->
	<footer style="bottom: -280px; width: 100%">
		<div class="inner">
			<div class="items">
				<div class="item">
					<p>오디가지</p>
					<p>(주)오디가지 대표이사: 오딩이</p>
					<p>대표전화 : 1544-9970</p>
					<p>FAX : 02-599-3111</p>

				</div>
				<div class="item">
					<p>회사 정보</p>
					<p>주소: 서울특별시 강남구 테헤란로10길 9 그랑프리 빌딩</p>
					<p>사업자등록번호: 851-87-00622</p>
					<p>호스팅 업체: (주)KH정보교육원</p>
				</div>
				<div class="item">
					<p>상담시간 안내</p>
					근무시간 정보
					<p>평일 09:00 - 18:00</p>
					<p>(토/일요일 및 공휴일 휴무)</p>
					<p></p>
				</div>
			</div>
		</div>
	</footer>


</body>
</html>