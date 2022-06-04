<?php
require 'hosting-plan.php';
require 'php/check_user.php';
if ( ($date<$hosting_finish_date) && (($days_left)<15) ) echo "Hosting Plan Will End In $difference->d Day(s)";
?>
<!doctype html>
<html>
<header>

	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<link rel="stylesheet" href="icons/fontawesome-free-5.12.0-web/css/all.css">
	<link rel="stylesheet" href="bootstrap-4.4.1-dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
	<link rel="stylesheet" href="LeafLet/leaflet.css">
	<link rel="stylesheet" href="css/main.css">

</header>
<title>M.Home</title>
<body>

<div class="loader" style="
			background-color:transparent;
			background-color:rgb(0,0,0,0.3);
			position:fixed;
			z-index:999;
			top:0px;
			bottom:0px;
			width:100%;		
">
	<div style="
				position:fixed;
				width:100px;
				height:25px;
				top:0px;
				bottom:0px;
				left:0px;
				right:0px;
				margin:auto;
				background-color:orange;
				border-radius:4px;
				border:1px solid black;
				font-weight:bold;
				box-shadow: 0px 0px 5px #333;
	">
Loading...
	</div>
</div>


<!--main-container-->
	<div class="main-container">
	
		<!--header-->
			<div class="header home-header">

				<div class="logo">
				<img src="logo.png" >
				</div>

				<section class="action">
					<form action="index.php" method="GET" class="sign-out-form"><input name="sign-out" type="hidden" value="sign-out"></form>
					<i class="fas fa-sign-out-alt sign-out-btn"></i>
					
				</section>
				
			</div>
		<!--end header-->

		<!--home-->

			<div class="home">

			<!--home_gif-->
				<div class="home-gif"></div>
			<!--end home_gif-->

			<!--home-nav-bar-->
			
				<ul class="home-nav-bar">
					<li onclick="window.location='accounts.php';"><i class="fas fa-user"></i>Accounts</li>
					<li onclick="window.location='stock.php';"><i class="fas fa-cube"></i>Stock</li>
					<li onclick="window.location='invoices.php';"><i class="fas fa-shopping-cart"></i>Invoices</li>
					<li onclick="window.location='payments.php';"><i class="fas fa-receipt"></i>Payments</li>
					<li onclick="window.location='journal.php';"><i class="fas fa-book"></i>Journal</li>
					<li onclick="loader_show();inventory_modal()"><i class="fas fa-calculator"></i>Total</li>
					<li onclick="loader_show();all_items_modal()"><i class="fas fa-cubes"></i>All Items</li>
					<li onclick="loader_show();loss_profit_modal()"><i class="fas fa-chart-bar"></i>L/P</li>
					<li onclick="loader_show();users_body();"><i class="fas fa-users"></i>Users</li>
					<li onclick="backup();"><i class="fas fa-save"></i>BackUp</li>
					<li onclick="restore();"><i class="fas fa-undo"></i>Restore</li>
				</ul>
			
			<!--end home-nav-bar-->

			</div>

		<!--end home-->



	</div>
<!--end main-container -->

<script src="LeafLet/leaflet.js"></script>
<script src="javascript/jquery.min.js"></script>
<script src="javascript/ajax_get.js"></script>
<script src="javascript/ajax_post.js"></script>
<script src="javascript/main.js"></script>

</body>
</html>