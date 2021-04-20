<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>search.jsp</title>
<jsp:include page="include/resource.jsp"></jsp:include>
<style>

	.container{ 
		height:100%; /* 컨텐츠를 가운데 정렬하기 위한 설정*/
		width: 100%;
		display: flex;
		flex-wrap: nowrap;
		align-items:center; /* 컨텐츠를 가운데 정렬하기 위한 설정*/
		align-content:center; /* 컨텐츠를 가운데 정렬하기 위한 설정*/
		flex-direction:column;
		padding-bottom:300px;
		
	}

	#rowum{ 
		z-index:0;/*상단탭 가리지 않게 하기 위한 설정*/
		position:relative;
		top:20px;
		
	}
	
	section{/*검색 결과 설명 섹션 설정*/
		margin-top:10px;
		background-color: #cecece;
	}

	.btn{/*한영버튼 크기 설정*/
		font-size: 13px;
	}
	.btn-group{/*한영 버튼 가운데 정렬*/
	 	display:flex;
	 	justify-content:center;
	 	align-item:center;
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
	
	/*상단탭 css*/
	.top_nav{
		top:0;
		display:flex;
		position: fixed;
		width: 100%;
		height:50px;
		padding-top:5px;
		padding-bottom:20px;
		border-bottom: 10px solid #white;
		/*상단탭 가리지 않게 하기 위한 설정*/
		z-index:1; 
		background-color:white;
		justify-content:flex-start;
		
		
		
	}
	/* 검색어 창*/
	#keywordInsert{
		margin-left:5px;
		height: 32px;
		border:none;
		focusable:none;
	}
	/* 검색 버튼 */
	#searchLogo{
		margin-left:20px;
		display:inline;
		flex-grow:1;
		height:20px;
		width:18px;
		
	}
	/* 검색어 창 포커스 되었을 때 설정 */
	input:focus{
		outline:none;
	}
	
	/* placeholder 속성에 대해 */
	::placeholder{
		font-size:0.7rem;
	}
	
	.form{
		display:inline;
	}
	
</style>
</head>
<body>
<nav class="top_nav">
	<form class="form">
		<img src="${pageContext.request.contextPath }/resources/svg/searchIcon.svg" class="button" type="button" id="searchLogo"/>
		<input class="input" placeholder="검색어를 입력해 주세요" id="keywordInsert">
	</form>
</nav>
	<section class="py-5 text-center container"><!-- 검색 결과 설명 섹션 -->
		<p></p>
	    <div class="row py-lg-5">
	      <div class="col-lg-6 col-md-8 mx-auto">
	        <!-- 여기 다 검색결과 개수 표시, 폰트 두껍게_짙은 회색-->
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
<jsp:include page="include/bottom_nav.jsp"></jsp:include><!-- 하단 탭 -->
</body>
<script>
	//search 화면이라면 search메뉴탭을 활성화 시킨다_2021.04.20
	$(document).ready(function(){
		//일단 모든 nav__link--active 활성화 클래스를 제거하고 
		$("#home").removeClass("nav__link--active");
		$("#category").removeClass("nav__link--active");
		$("#setting").removeClass("nav__link--active");
		//탭을 클랙했으니까 해당 클래스에 탭 추가 
		$("#search").addClass("nav__link--active");
		
	});	
	
	let enMode = true;//임시
	
	//검색버튼을 누르면 input의 텍스트를 가져와 ajax요청을 해서 명언 응답받기_2021.04.20
	$("#searchLogo").on("click", function(){
		//검색창의 텍스트를 가져온다.
		let searchKeyword = $("#keywordInsert").val();
		console.log(searchKeyword);
		$.ajax({
			url:"${pageContext.request.contextPath }/search_data.do?keyword=" + searchKeyword,
			method:"GET",
			success:function(data){
				console.log(data);
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
					} else { //지금이 영어 모드이면
						$('#'+i).find('.card-body').append($('<p class="card-text">' + item['descripE'] + '</p>')); 
						$('#'+i).find('.card-body').append($('<p class="card-subtitle">' + '-' + item['authE'] + '</p>'));
					}
				
				}
			}
		})
		
	});
	
</script>
</html>