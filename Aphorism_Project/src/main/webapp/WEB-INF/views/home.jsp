<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="include/resource.jsp"></jsp:include>
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/spinner.css" /><!-- 스피너 css -->
<meta charset="UTF-8">
<title>home.do</title>
<style>
	html, body{ /*.container가 하단탭 나머지 부분을 모두 차지하게 하기 위해 우선 설정 */
		height:100%;
		width: 100%;
	}
	
	html.dark{
		background: #121212;
		color:#bbbbbb;
	}

	button{
		border:0; 
		outline:0;
		background-color:#ffffff;
	}
	
	/* 뷰페이지 레이아웃 구성 */
	.container{ 
		height:84%; /* 컨텐츠를 가운데 정렬하기 위한 설정 */
		width: 100%;
		display: flex;
		flex-wrap: nowrap;
		justify-content:space-between; /* prev, next버튼이 컨텐츠 크기에 따라 위치가 바뀌는 문제 해결 */
		align-items:center; /* 컨텐츠를 가운데 정렬하기 위한 설정 */
		align-content:center; /* 컨텐츠를 가운데 정렬하기 위한 설정 */
		
		
	}
	#prev {
		margin-right: 8px;
		padding-left: 0px;
	}
	#next {
		margin-left: 8px;
		padding-right: 0px;
	}
	.row-xs-8 { /* description 담은 div */
		margin: 0px 30px
	}
	#author { 
		text-align: center;
	}
	#description {
		text-align: center;
	}
	
	
	/* 반응형 폰트 크기 설정하는 미디어 쿼리_홈버전 */
	@media (max-width:360px){html{font-size:20px;}}
	
	@media (min-width:360px) and (max-width:799px){html{font-size:21px;}}
	
	@media (min-width:361px) and (max-width:839px){html{font-size:22px;}}
	
	@media (min-width:840px) and (max-width:879px){html{font-size:24px;}}
	
	@media (min-width:880px){html{font-size:28px;}}
	
	/* 한영버튼 과 좋아요버튼 레이아웃 설정 */
	#lan_like{
		display:flex;
		width:68px;

	}
	#language_btn { /* 한영 전환 버튼 */
		padding: 0 0 0 0px;
		
	}
	#like_border_btn{ /* 좋아요 버튼 */
		padding: 0 0 0 0px;	
	}
	#like_border_img{
		width:24px;
		height:24px;
	}
	
	
	
</style>
</head>
<body>
	<div class="container">
		<div class="row-xs-2"><!-- prev버튼 -->
			<button type="button" id="prev">
				<i class="material-icons nav__icon">chevron_left</i>
			</button>
		</div>
		<div class="row-xs-8"><!--명언출력부-->
			<p id="id" hidden></p>
			<p id="description"></p>
			<p id="author"></p>
			<div id="lan_like">
				<button class="nav__link" id="language_btn"><!-- 한영전환 버튼 -->
					<i class="material-icons nav__icon" id="lan_icon">language</i>
					<span class="material-icons-outlined" id="lan">en</span>
				</button>
				<button class="nav__link" id="like_border_btn">
					<i class="material-icons" id="like_border_img">favorite_border</i>
					<span class="material-icons-outlined" id="like">like</span>
				</button>
			</div>
		</div>
		<div class="row-xs-2"><!-- next버튼 -->
			<button type="button" id="next">
				<i class="material-icons nav__icon">chevron_right</i>
			</button>
		</div>
	</div>
<div class="back-drop"> <!--home 화면 처음 로딩시 나오는 스피너 svg (구현보류)-->
	<img src="${pageContext.request.contextPath }/resources/svg/Spinner_font_awesome.svg" alt="" />
</div>
<jsp:include page="include/bottom_nav.jsp"></jsp:include>
</body>
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<script>
	//home화면이라면 home메뉴탭을 활성화 시킨다_2021.04.12
	$(document).ready(function(){
		// 한영전체설정_2021.04.26
		if(!(getCookie('isKr')=='yes')){ //한글모드가 아니면 영어버튼 클릭
			$("#language_btn").trigger("click");
			
		}
		//일단 모든 nav__link--active 활성화 클래스를 제거하고 
		$("#category").removeClass("nav__link--active");
		$("#search").removeClass("nav__link--active");
		$("#setting").removeClass("nav__link--active");
		//탭을 클랙했으니까 해당 클래스에 탭 추가 
		$("#home").addClass("nav__link--active");
		
	});
	
	//배경색설정효과_2021.04.27
	if(getCookie('theme')!=null) {
		let theme = getCookie('theme');
		if(theme=='original'){
		
		} else if(theme=='dark'){
			//home
			$('.container').css('background','#121212');
			$('.container').css('color','#bbbbbb');
			$('body').css('background','#121212');
			$('body').css('color','#bbbbbb');
			$('button').css('background-color','#121212');
			$('button').css('color','#bbbbbb');
			//nav
			$('.nav').css('background','#121212');
			$('.nav').css('color','#bbbbbb');
			$('.material-icons-outlined').css('text-color','#bbbbbb');
		} else if(theme=='fa'){
			//home
			$('.container').css('background','#135fa1');
			$('.container').css('color','#ffffff');
			$('body').css('background','#135fa1');
			$('body').css('color','#ffffff');
			$('button').css('background-color','#135fa1');
			$('button').css('color','#ffffff');
			//nav
			$('.nav').css('background','#1976d2');
			$('.nav').css('color','#ffffff');
		}
	}
	
	//카카오 메세지
	let kakaodes = null;
	let kakaoaut = null;
	
	//language_btn을 누르면 바로 언어가 바뀌게 하기 위해 담을 변수들
	let desK = null;
	let autK = null;
	let desE = null;
	let autE = null;
	//영어모드 인지
	let enMode = false;
	//language_btn 시각적으로 토글기능 부여_2021.04.13
	$("#language_btn").on("click", function(){
		//버튼 en -> kr
		let lan = $("#lan").text();
		if(lan == "en") {
			$("#lan").text("kr");
			$("#lan_icon").addClass("nav__link--active");
			
			enMode = true; // en버튼 누르면 텍스트가 kr로바뀌면서 영어모드가됨
			
			$("#description").text(desE);
			$("#author").text("-"+autE);
			
			kakaodes = desE; //영어이면 공유할 텍스트를 영어를 넣기
			kakaoaut = autE;
			
			// 영어 폰트 선택 시 폰트 수정_2021.04.28
			if(getCookie('enFont')!=null) { 
				let font = getCookie('enFont');
				let inputFont = null; // 쿠키 밸류에 따른 폰트속성을 담을 변수
				switch(font) {
					case "Indie":
						inputFont = "'Indie Flower',cursive";
						break;
					case "Dancing":
						inputFont = "'Dancing Script', cursive";
						break;
					case "Roboto":
						inputFont = "'Roboto', sans-serif";
						break;
					case "Patrick":
						inputFont = "'Patrick Hand', cursive";
						break;
					case "Cormorant":
						inputFont = "'Cormorant Garamond', serif";
						break;
					case "Unif":
						inputFont = "'UnifrakturCok', cursive";
						break;
					case "Monoton":
						inputFont = "'Monoton', cursive";
						break;
					case "Fredericka":
						inputFont = "'Fredericka the Great', cursive";
						break;
				}
				$("#description").css('font-family',""+inputFont);
				$("#author").css('font-family',""+inputFont);
			}
		} else {
			$("#lan").text("en"); // kr을 누르면 불빛이 사라지고 텍스트가 en으로 바뀌면서 한글모드가 됨
			$("#lan_icon").removeClass("nav__link--active");
			enMode = false;
			$("#description").text(desK);
			$("#author").text("-"+autK);
			
			kakaodes = desK; //한글이면 공유할 텍스트를 한글로 
			kakaoaut = autK;
			
			// 한글 폰트 선택 시 폰트 수정_2021.04.28
			if(getCookie('krFont')!= null) { 
				let font = getCookie('krFont');
				let inputFont = null; // 쿠키 밸류에 따른 폰트속성을 담을 변수
				switch(font) {
					case "Noto":
						inputFont = "'Noto Sans KR', sans-serif";
						break;
					case "Gaegu":
						inputFont = "'Gaegu', cursive";
						break;
					case "Cute":
						inputFont = "'Cute Font', cursive";
						break;
					case "Single":
						inputFont = "'Single Day', cursive";
						break;
					case "DoHyeon":
						inputFont = "'Do Hyeon', sans-serif";
						break;
					case "Gothic":
						inputFont = "'Gothic A1', sans-serif";
						break;
					case "Black":
						inputFont = "'Black Han Sans', sans-serif";
						break;
				}
				$("#description").css('font-family',""+inputFont);
				$("#author").css('font-family',""+inputFont);	
			}
		}
	});
	
	//전체 명언의 사이즈
	let size = 0;
	
	//home메뉴 처음 ajax 명언 출력_2021.04.13
	$(document).ready(function(){
		$.ajax({
			url:"${pageContext.request.contextPath }/quote.do?id=0&btn=not",// 맨처음 페이지 로딩할때는 명언을 무작위로 가져오게 하기위해 id=0으로, 
					// 아무버튼도 누르지 않았으니까 btn=not으로 quote.do에 요청한다. 
			method:"GET",
			success:function(data) {
				$("#id").text(""+data["id"]);
				desK = data["descripK"];
				desE = data["descripE"];
				autK = data["authK"];
				autE = data["authE"];
				size = data["size"]; // 총 명언의 갯수 수정
				if(enMode) { //지금이 영어모드이면 
					$("#description").text(""+data["descripE"]);
					$("#author").text("-"+data["authE"]);
					
					kakaodes = desE; //영어이면 공유할 텍스트를 영어를 넣기
					kakaoaut = autE;
				
					if(getCookie('enFont')!=null) { // 영어 폰트 선택 시 폰트 수정_2021.04.28
						let font = getCookie('enFont');
						let inputFont = null; // 쿠키 밸류에 따른 폰트속성을 담을 변수
						switch(font) {
							case "Indie":
								inputFont = "'Indie Flower',cursive";
								break;
							case "Dancing":
								inputFont = "'Dancing Script', cursive";
								break;
							case "Roboto":
								inputFont = "'Roboto', sans-serif";
								break;
							case "Patrick":
								inputFont = "'Patrick Hand', cursive";
								break;
							case "Cormorant":
								inputFont = "'Cormorant Garamond', serif";
								break;
							case "Unif":
								inputFont = "'UnifrakturCok', cursive";
								break;
							case "Monoton":
								inputFont = "'Monoton', cursive";
								break;
							case "Fredericka":
								inputFont = "'Fredericka the Great', cursive";
								break;
						}
						$("#description").css("font-family",""+inputFont);
						$("#author").css("font-family",""+inputFont);
					}
				} else { //지금이 한글 모드이면
					$("#description").text(""+data["descripK"]);
					$("#author").text("-"+data["authK"]);
					
					kakaodes = desK; //한글이면 공유할 텍스트를 한글로 
					kakaoaut = autK;

					if(getCookie('krFont')!= null) { // 한글 폰트 선택 시 폰트 수정_2021.04.28
						let font = getCookie('krFont');
						console.log(font);
						let inputFont = null; // 쿠키 밸류에 따른 폰트속성을 담을 변수
						switch(font) {
							case "Noto":
								inputFont = "'Noto Sans KR', sans-serif";
								break;
							case "Gaegu":
								inputFont = "'Gaegu', cursive";
								break;
							case "Cute":
								inputFont = "'Cute Font', cursive";
								break;
							case "Single":
								inputFont = "'Single Day', cursive";
								break;
							case "DoHyeon":
								inputFont = "'Do Hyeon', sans-serif";
								break;
							case "Gothic":
								inputFont = "'Gothic A1', sans-serif";
								break;
							case "Black":
								inputFont = "'Black Han Sans', sans-serif";
								break;
						}
						console.log(inputFont);
						$("#description").css("font-family",""+inputFont);
						$("#author").css("font-family",""+inputFont);	
					}
				}
				
				// 명언의 좋아요 여부 검사
				isLike(data["id"]);
	
			}
		})
	});
	
	//prev버튼 클릭시 앞id의 명언 ajax출력_2021.04.12
	$("#prev").on("click", function(){
		
		let viewId = $("#id").text()-1; //이전 id의 명언을 불러오기위해 전달할 id값
		if(viewId == 0) { //현재 명언의 id가 1이라면 id=0인 명언은 없으니까 전체 명언의 중간을 불러오기
			viewId = parseInt(size/2);
			if(viewId == NaN) {
				viewId +=1;
			}
		}
		
		$.ajax({
			url:"${pageContext.request.contextPath }/quote.do?id="+ viewId+"&btn=prev",
			method:"GET",
			success:function(data) {
				$("#id").text(""+data["id"]);
				desK = data["descripK"];//한영모드 기능 지원을 위해 전역변수에 값을 담음
				desE = data["descripE"];
				autK = data["authK"];
				autE = data["authE"];
				if(enMode) { //지금이 한글모드이면  
					$("#description").text(""+data["descripE"]);
					$("#author").text("-"+data["authE"]);
					
					kakaodes = desE; //영어이면 공유할 텍스트 영어로
					kakaoaut = autE;
					
				} else { //지금이 영어 모드이면
					$("#description").text(""+data["descripK"]);
					$("#author").text("-"+data["authK"]);
					
					kakaodes = desK; //한글이면 공유할 텍스트를 한글로 
					kakaoaut = autK;
				}
				
				// 명언의 좋아요 여부 검사
				if(isLike(data["id"]) == false){
					$("#like").text('like');
					$("#like_border_img").text('favorite_border');
					$('#like_border_img').css('color','');
				}
			}
		})
	});
	
	//next버튼 클릭시 앞id의 명언 ajax출력_2021.04.12
	$("#next").on("click", function(){
		
		let viewId = parseInt($("#id").text());
		if(viewId == size) { //현재명언의 id가  전체 명언의 크기와 같다면 다음 id의 명언이 존재하지 않으니
			viewId = parseInt(size/2); // 명언의 중간부터 보여주기 
			if(viewId == NaN) {
				viewId +=1;
			}
		}
		
		$.ajax({
			url:"${pageContext.request.contextPath }/quote.do?id="+ viewId +"&btn=next",
			method:"GET",
			success:function(data) {
				$("#id").text(""+data["id"]);
				desK = data["descripK"]; //한영모드 기능 지원을 위해 전역변수에 값을 담음
				desE = data["descripE"];
				autK = data["authK"];
				autE = data["authE"];
				if(enMode) { //지금이 영어 
					$("#description").text(""+data["descripE"]);
					$("#author").text("-"+data["authE"]);
					
					kakaodes = desE; //영어이면 공유할 텍스트 영어로
					kakaoaut = autE;
					
				} else { //지금이 한글 모드이면
					$("#description").text(""+data["descripK"]);
					$("#author").text("-"+data["authK"]);
					
					kakaodes = desK; //한글이면 공유할 텍스트를 한글로 
					kakaoaut = autK;
				}
				
				// 명언의 좋아요 여부 검사
				if(isLike(data["id"]) == false){
					$("#like").text('like');
					$("#like_border_img").text('favorite_border');
					$('#like_border_img').css('color','');
				}
				
			}
		})
	});
	
	// 좋아요 버튼 눌렀을 때_2021.04.23
	$("#like_border_btn").on("click", function(){
		//텍스트와 버튼 svg바꾸기
		let text = $("#like").text();
		if(text=="like"){ //좋아요를 눌렀다면 
			$("#like").text('unlike');
			$("#like_border_img").text('favorite');
			$('#like_border_img').css('color','#f44336');
			
			//현재 명언의 id값
			let id = $('#id').text();
			
			//'like'키 값의 쿠키가 존재하는지 검사
			if(getCookie('like') == null){ // 좋아요가 처음이라면
				setCookie('like', id); //쿠키생성
			} else if(getCookie('like') == ''){ // 'like' 쿠키가 이미 존재 하는데 비어있다면			
				// 쿠키 저장
				setCookie('like', id);
			} else {
				// 쿠키를 가져온다.
				let cookie = getCookie('like').toString();
				// 쿠키가 문자열로 저장되므로 새로저장할 명언을 하나의 문자열로 합친다. 
				let like = cookie + '@' + id;				
				// 기존 쿠키 삭제
				setCookie('like','');
				// 쿠키 저장
				setCookie('like', like);
			}
			
		} else { //좋아요를 취소한다면
			$("#like").text('like');
			$("#like_border_img").text('favorite_border');
			$('#like_border_img').css('color','');
			
			//쿠키에서 삭제
			//1.현재 쿠키밸류를 얻어옴
			let currentCookie = getCookie('like');
			//2.현재명언id를 쿠키벨류에서 제거
			let id = $('#id').text();
			futureCookie = currentCookie.replace(id, '');
			
			setCookie('like', futureCookie);
			
			//3.골뱅이정리
			let reg = /@+/; //@가 하나이상인지 검사하는 정규표현식
			
			if(reg.test(getCookie('like'))) {
				let newCookie = getCookie('like').replaceAll('@@','@'); // @@는 @로 대체
				setCookie('like', newCookie);
			}
			
		}
		
	});
	
	Kakao.init('3b2fce3e5669de0e789ac5e528620099');//카카오에서 발급받은 javascript키로 초기화 한다.
	
	

	
	//명언 출력부를 더블클릭했을때 카카오 API를 이용해서 공유하기_2021.04.30 
	$("#description").dblclick(function(){
		Kakao.Link.createDefaultButton({
			  container: '#description',
			  objectType: 'text',
			  text:
			    '' + kakaodes + '\n -' + kakaoaut,
			  link: {
			    mobileWebUrl:
			      'http://localhost:8888/aphorism/home.do',
			    webUrl:
			      'http://localhost:8888/aphorism/home.do',
			  },
			});
	});
	
	//쿠키 생성 메소드_2021.04.23
	function setCookie(key, value) {
	    let expiration_date = new Date();
	   	expiration_date.setFullYear(expiration_date.getFullYear()+1);// 시간을 1년으로 지정
	    document.cookie = key + "=" + escape(value) + "; path=/; expires=" + expiration_date.toUTCString();
	}
	
	
	//쿠키 가져오는 메소드_2021.04.23
	function getCookie(key) {
		let result = null;
		let cookie = document.cookie.split(';');// 쿠키 문자열을 ';'를 기준으로 나누고 배열을 리턴 
	    cookie.some(function(item){ // cookie 배열을 가지고 some의 테스트 함수를 실행시켜 하나의 엘리먼트라도 true면은 true를 리턴하는 메소드 .some() (근데 여기선 걍 배열 요소들 가지고 함수 실행만)
	      
	        item = item.replace(' ', '');// 공백을 제거
	 
	        let dic = item.split('=');// 각 인덱스를 '='기준으로 또 나눔
	 
	        if (key === dic[0]) { // = 의 좌측이 전달받은 key 와 같다면
	            result = dic[1]; // 결과로 value를 담고 (쿠키값 얻어내기)
	            return true;    // getCookie메소드를 종료
	        }
	    });
	    return result; //키값과 일치하는 쿠키가 없다면 null을 리턴
	}
	
	//현재 명언의 좋아요 여부 검사하는 메소드_2021.04.23
	function isLike(id){
		if(getCookie('like')!=null) {
			let like = getCookie('like').split('@'); //쿠키밸류를 배열로 리턴
			for(let ele of like) {
				if(parseInt(ele) == id){ //배열의 요소가 현재 명언의 id와 같다면 
					//빨간하트로 바꿔주기
					$("#like").text('unlike');
					$("#like_border_img").text('favorite');
					$('#like_border_img').css('color','#f44336');
					return true; //종료
				}
			}
			return false;
		}	
	}

</script>
</html>