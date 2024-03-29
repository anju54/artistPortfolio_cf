
<cfset VARIABLES.artistprofileService = CreateObject('component', 'component.artistProfileService') />

<!--- <cfset VARIABLES.returnData = QueryNew("")/> --->

<cfset VARIABLES.returnData = VARIABLES.artistprofileService.getPublicprofileInfo(artistId=URL.id) />

<cfif VARIABLES.returnData.recordCount eq 0>

	<cflocation url="userNotFound.cfm">
<cfelse>
<!DOCTYPE HTML>
<html>

<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>Artist Profile</title>
	<meta name="viewport" content="width=device-width, initial-scale=1">

	<!-- Facebook and Twitter integration -->
	<meta property="og:title" content="" />
	<meta property="og:image" content="" />
	<meta property="og:url" content="" />
	<meta property="og:site_name" content="" />
	<meta property="og:description" content="" />
	<meta name="twitter:title" content="" />
	<meta name="twitter:image" content="" />
	<meta name="twitter:url" content="" />
	<meta name="twitter:card" content="" />

	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
	<link href="https://fonts.googleapis.com/css?family=Space+Mono" rel="stylesheet">
	<link href="https://fonts.googleapis.com/css?family=Kaushan+Script" rel="stylesheet">
	<!-- <link rel="stylesheet" href="css/loader.css"> -->
	<style>
		#prev-img {
			opacity: 100;
			filter: alpha(opacity=100);
			position: fixed;
			/* or absolute */
			top: 100px;
			left: 30%;
		}

		#closePrev {

			position: absolute;
			left: 50%;
			top: 60px;
		}

		.over {
			background-color: black;
			position: fixed;
			width: 100%;
			height: 100%;
			z-index: 1000;
			top: 0px;
			left: 0px;
		}
	</style>

	<!-- Animate.css -->
	<link rel="stylesheet" href="../css/publicProfilecss/animate.css">
	<!-- Icomoon Icon Fonts-->
	<link rel="stylesheet" href="../css/publicProfilecss/icomoon.css">
	<!-- Bootstrap  -->
	<link rel="stylesheet" href="../css/publicProfilecss/bootstrap.css">

	<!-- Theme style  -->
	<link rel="stylesheet" href="../css/publicProfilecss/style.css">


	<!-- <script type="text/javascript" src="/js/jquery-1.10.2.min.js"></script> -->

	<!-- Modernizr JS -->
	<script src="../js/publicProfilejs/modernizr-2.6.2.min.js"></script>
	<!-- FOR IE9 below -->
	<!--[if lt IE 9]>
	<script src="js/respond.min.js"></script>
	<![endif]-->

	<script type="text/javascript" src="../js/config.js"></script>



</head>

<body>

	<div id="page">
		<header id="fh5co-header" class="fh5co-cover js-fullheight" role="banner"
			style="background-image:url(assets/publicProfileimages/cover_bg_3.jpg);"
			data-stellar-background-ratio="0.5">
			<div class="overlay" id="mainColorDiv"></div>
			<div class="container">
				<div class="row">
					<div class="col-md-8 col-md-offset-2 text-center">
						<div class="display-t js-fullheight">
							<div class="display-tc js-fullheight animate-box" data-animate-effect="fadeIn">
								<img class="profile-thumb" id="profilePic"
									src="../assets/images/default-profile-pic.png"></img>
								<h1><span id="name"></span></h1>
								<div id="paintingType">
									<!-- <h3><span id="typeOfPainting">Oil Painting / Sand Painting</span></h3> -->
								</div>
								<p>
									<ul class="fh5co-social-icons">
										<li><a href="#" id="twitter"><i class="fa fa-tumblr-square"></i></a></li>
										<li><a href="#" id="facebook"><i class="fa fa-facebook-official"></i></a></li>
										<li><a href="#" id="linkedin"><i class="fa fa-linkedin-square"></i></a></li>
									</ul>
								</p>
							</div>
						</div>
					</div>
				</div>
			</div>
		</header>

		<div id="fh5co-about" class="animate-box">
			<div class="container">
				<div class="row">
					<div class=col-md-6></div>
					<div class="col-md-6 col-md-offset-2 text-center fh5co-heading">
						<h2>About Me</h2>
					</div>
				</div>
				<div class="row">
					<div class="col-md-6">
						<ul class="info">
							<li>
								<span class="first-block">Full Name:</span>
								<span class="second-block" id="fullName"></span>
							</li>
							<li>
								<span class="first-block">Email:</span>
								<span class="second-block" id="email"></span>
							</li>
						</ul>
					</div>
					<div class="col-md-6">
						<h2>Hello There!</h2>
						<p id="aboutMe">
							Default Message
						</p>

					</div>
				</div>
			</div>
		</div>

		<div id="fh5co-work" class="fh5co-bg-dark">
			<div class="container">
				<div class="row animate-box">
					<div class="col-md-8 col-md-offset-2 text-center fh5co-heading">
						<h2>My Paintings</h2>
					</div>


					<div class="row">
						<div class="col-md-4"></div>
						<div class="col-sm-8" style="float:right">
							<h3 id="warningMsg"></h3>
						</div>
					</div>

					<div class="row">
						<div id="publicImgDiv"></div>
					</div>

					<div class="row">
						<div class="col-md-6 col-md-offset-3">
							<ul id="pagination-demo" class="pagination-sm flex-wrap mt-50 mb-70 justify-content-center">
							</ul>
						</div>
					</div>
				</div>


			</div>

			<div class="gototop js-top">
				<a href="#" class="js-gotop"><i class="icon-arrow-up22"></i></a>
			</div>

			<!-- jQuery -->
			<script src="../js/publicProfilejs/jquery.min.js"></script>
			<!-- jQuery Easing -->
			<script src="../js/publicProfilejs/jquery.easing.1.3.js"></script>
			<!-- Bootstrap -->
			<script src="../js/publicProfilejs/bootstrap.min.js"></script>
			<!-- Waypoints -->
			<script src="../js/publicProfilejs/jquery.waypoints.min.js"></script>
			<!-- Stellar Parallax -->
			<script src="../js/publicProfilejs/jquery.stellar.min.js"></script>
			<!-- Easy PieChart -->
			<script src="../js/publicProfilejs/jquery.easypiechart.min.js"></script>
			<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
			<script type="text/javascript" src="../js/jquery.twbsPagination.js"></script>
			<script type="text/javascript" src="../js/jquery.twbsPagination.min.js"></script>

			<!-- Main -->
			<script src="../js/publicProfilejs/main.js"></script>
			<script src="../js/artistPublicProfile.js"></script>

</body>
</html>
</cfif>