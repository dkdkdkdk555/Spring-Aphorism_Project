<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<jsp:include page="../include/resource.jsp"></jsp:include>
<title>category.jsp</title>
<style>
	/*상단탭 css*/
	.top_nav{
		top:0;
		display:flex;
		position: fixed;
		width: 100%;
		height:50px;
		overflow-x:auto; /*기본 스크롤 상태*/
		padding-left:0px;
		padding-right:0px;
		padding-top:10px;
		border-bottom: 5.5px solid #e6e6e6;
		/*상단탭 가리지 않게 하기 위한 설정*/
		z-index:1; 
		background-color:white;
		margin-color:white;
		
	}
	
	/*스크롤 기능은 유지하면서 스크를바는 없애기*/
	.top_nav::-webkit-scrollbar{
		display:none;
	}
	
	/*각각의 카테고리 메뉴 */
	li{
		display:flex;
		flex-grow:1;
		list-style:none;
		padding:0 10px;
		font-family: 'Indie Flower',cursive;
		
	}

	/* 반응형 폰트 크기 설정하는 미디어 쿼리_category탭 버전*/
	@media (max-width:360px){html{font-size:17px;}}
	@media (min-width:360px) and (max-width:799px){html{font-size:18px;}}
	@media (min-width:361px) and (max-width:839px){html{font-size:20px;}}
	@media (min-width:840px) and (max-width:879px){html{font-size:22px;}}
	@media (min-width:880px){html{font-size:24px;}}
	/*반응형 값 보정*/
	@media (min-width:1150px) and (max-width:1220px){ #love{padding-left:30px;}}
	@media (min-width:1221px) and (max-width:1320px){ #love{padding-left:40px;}}
	@media (min-width:1321px) and (max-width:1420px){ #love{padding-left:50px;}}
	@media (min-width:1421px) and (max-width:1500px) { #love{padding-left:60px;}}
	@media (min-width:1521px) and (max-width:1661px) { #love{padding-left:70px;}}
	@media (min-width:1670px){ #love{padding-left:80px;}}
	
	.container{ 
		height:100%; /* 컨텐츠를 가운데 정렬하기 위한 설정*/
		width: 100%;
		display: flex;
		flex-wrap: nowrap;
		align-items:center; /* 컨텐츠를 가운데 정렬하기 위한 설정*/
		align-content:center; /* 컨텐츠를 가운데 정렬하기 위한 설정*/
		flex-direction:column;
		padding-bottom:300px;/* 컨텐츠가 하단탭에 가려지지 않도록 */
		
	}
	
	#rowum{ 
		z-index:0;/*상단탭 가리지 않게 하기 위한 설정*/
		position:relative;
		top:20px;
		
	}
	
	.card{
		border-radius: 15px; /*모서리 둥글게*/
		border: 3.8px solid #e6e6e6;
	}
	
	/*카테고리 설명 섹션 설정*/
	section{
		background-color: #cecece;
	}
	

	/*임시*/
	.card-text {
		text-align: center;
	}
	
	.card-subtitle {
		text-align: center;
	}
	
	
	#mainImage{ /*카테고리 소개 이미지 레이아웃 조절*/
		display:block;
		align:center;
		height: 100px;
		width: 100px;
		margin-bottom:20px;
		margin-right:auto;
		margin-left:auto;
		margin-top:20px;
	}
	
	/*한영 버튼 설정*/
	.btn{
		font-size: 13px;
	}
	
	.btn-group{/*한영 버튼 가운데 정렬*/
	 	display:flex;
	 	justify-content:center;
	 	align-item:center;
	}
	
</style>
</head>
<body>
<jsp:include page="../include/category_tab.jsp"></jsp:include><!-- 카테고리 설명 섹션 -->
	<section class="py-5 text-center container">
	    <div class="row py-lg-5">
	      <div class="col-lg-6 col-md-8 mx-auto">
	        <img src="${pageContext.request.contextPath }/resources/svg/love.svg" id="mainImage"/>
	        <div class="btn-group">
				<button type="button" class="btn btn-outline-secondary" id="en">English mode</button>
				<button type="button" class="btn btn-outline-secondary" id="kr">Korean mode</button>
			</div>
	      </div>
	    </div>
  </section>
<div class="container"><!-- 데이터 출력 부 --> 
	<div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-3" id="rowum">

	</div>
</div>
<jsp:include page="../include/bottom_nav.jsp"></jsp:include>
</body>
<script>
	//category화면이라면 category메뉴탭을 활성화 시킨다_2021.04.16
	$(document).ready(function(){
		//일단 모든 nav__link--active 활성화 클래스를 제거하고 
		$("#home").removeClass("nav__link--active");
		$("#search").removeClass("nav__link--active");
		$("#setting").removeClass("nav__link--active");
		//탭을 클랙했으니까 해당 클래스에 탭 추가 
		$("#category").addClass("nav__link--active");
		
		// 한영전체설정_2021.04.26
		if(getCookie('isKr')=='yes'){
			$("#kr").trigger("click");//언어설정 한글이면 한글부터 보이게
		} else {
			$("#en").trigger("click");
		}
	});	
	
	//배경색설정효과_2021.04.27
	if(getCookie('theme')!=null) {
		let theme = getCookie('theme');
		if(theme=='original'){
		
		} else if(theme=='dark'){
			//home
			$('.top_nav').css('background','#121212');
			$('.top_nav').children('li').css('color','#bbbbbb');//상단탭 메뉴글자 색
			$('.container').css('background','#121212');
			$('body').css('background','#121212');
			$('section').css('background-color','#808e95');
			//nav
			$('.nav').css('background','#121212');
			$('.nav').css('color','#bbbbbb');
			$('.material-icons-outlined').css('text-color','#bbbbbb');
		} else if(theme=='fa'){
			//home
			$('.container').css('background','#135fa1');
			$('body').css('background','#135fa1');
			$('.top_nav').css('background','#1976d2');
			$('.top_nav').children('li').css('color','#e0e0e0');//상단탭 메뉴글자 색
			$('.col').css('background','#135fa1');
			$('section').css('background-color','#aed581');
			//nav
			$('.nav').css('background','#1976d2');
		
		}
	}

	
	//category 첫화면에서 아무것도 안보이니까 뭐라도 보이게하기_2021.04.19
	$(document).ready(function(){
		$("#love").trigger("click");//트리거로 강제 클릭
	});
	
	//클릭할 요소의 id를 가져올 변수_2021.04.19
	let id = "";
	
	//한영 모드 설정_2021.04.19
	let enMode = false;
	
	$("#en").on("click", function(){
		//버튼 효과
		$(".btn-group").children("button").attr('class', 'btn btn-outline-secondary');//우선 모든 버튼을 outline으로 만듬
		$(this).attr('class', 'btn btn-secondary'); // 그러곤 클릭한 버튼에서 outline제거
		//영어로 바꿈
		enMode = true;
		$(".top_nav").children('#'+id).trigger("click");// let id로 저장되어있는 카테고리바 li요소를 트리거로 클릭한다
		
	});
	
	$("#kr").on("click", function(){
		//버튼 효과
		$(".btn-group").children("button").attr('class', 'btn btn-outline-secondary');
		$(this).attr('class', 'btn btn-secondary');
		//한글로 바꿈
		enMode = false;
		$(".top_nav").children('#'+id).trigger("click");
	});
	
	//카테고리 li 선택시 명언데이터 불러오기_2021.04.16 -> 수정 4.17
	$(".top_nav").children("li").on("click", function(){
		//우선 모든 카테고리에 적용된 활성화 효과 지우기
		$('li').css('border-bottom', 'none');
		//클릭한 자식요소 li의 아이디 가져오기
		id = $(this).attr('id');
		//선택한 카테고리에 활성화 밑줄 효과 주기 
		$("#"+id).css('border-bottom', '3px solid #8080ff');
		
		//카테고리 설명이미지 바꾸기_2021.04.19
		$("#mainImage").attr('src', '${pageContext.request.contextPath }/resources/svg/' + id + '.svg');
		
		//이전에 추가되었던 데이터(태그) 모두 삭제
		$('#rowum').empty(); // 선택한 요소의 자식요소 모두를 삭제한다. (선택한 요소는 삭제되지 않음 (remove(), detach()와의 차이점)

		$.ajax({
			url:"${pageContext.request.contextPath }/category/data_category.do?category=" + id,
			method:"GET",
			success:function(data){
				for(let i=0; i<data.length; i++) {
					for(let j=0; i<data.length; i++) { //먼저 명언갯수만큼 col를 만들음 
						$('#rowum').append($('<div class="col" id="' + i + '">'+'</div>'));	
					}
					if(!$('.col').find('.card').length) { //.col 하위에 .card 가 존재하지 않는다면 => .length를 쓰는데 있다면 true 리턴, 없다면 false를 리턴
						$('.col').append($('<div class="card">'+'</div>'));		
					}	
					if(!$('.card').find('.card-body').length){
						$('.card').append($('<div class="card-body">'+'</div>'))
					}				
				}
				
				for(let i=0; i<data.length; i++) {
					let item = data[i];
					if(!enMode){ //지금이 영어 모드가 아니라면
						$('#'+i).find('.card-body').append($('<p class="card-text">' + item['descripK'] + '</p>')); // 각 col마다 다른 명언을 넣어야 하기 때문에 
						$('#'+i).find('.card-body').append($('<p class="card-subtitle">' + '-' + item['authK'] + '</p>'));
						
						// 폰트체 수정에 의한 폰트체 설정_2021.04.28 
						if(getCookie('krFont')!= null) { // 한글 폰트 선택 시 폰트 수정_2021.04.28
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
							$(".card-text").css("font-family",""+inputFont);
							$(".card-subtitle").css("font-family",""+inputFont);	
						}
						
					} else { //지금이 영어 모드이면
						$('#'+i).find('.card-body').append($('<p class="card-text">' + item['descripE'] + '</p>')); 
						$('#'+i).find('.card-body').append($('<p class="card-subtitle">' + '-' + item['authE'] + '</p>'));
						
						// 폰트체 수정에 의한 폰트체 설정_2021.04.28
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
							$(".card-text").css("font-family",""+inputFont);
							$(".card-subtitle").css("font-family",""+inputFont);
						}
					}
				}
			}
		})
	});
		
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
</script>
</html>