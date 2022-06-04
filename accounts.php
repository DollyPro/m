<?php
require 'hosting-plan.php';
require 'php/check_user.php';
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
<title>M.Accounts</title>
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
			<div class="header">

				<div class="logo">
				<img src="logo.png" >
				</div>

				<section class="action">
					<form action="index.php" method="GET" class="sign-out-form"><input name="sign-out" type="hidden" value="sign-out"></form>
					<i class="fas fa-sign-out-alt sign-out-btn"></i>
					<i onclick="loader_show();window.location='home.php'" class="fas fa-home"></i>
					<i onclick="show_menu();" class="fas fa-plus-square menu-btn"></i>
					
				</section>
				
			</div>
		<!--end header-->

		<!--menu-->
			<div class="menu">

				<ul>
				
					<li onclick="insert_account_modal();" ><i style="color:green;" class="fas fa-user-plus"></i> <section>New</section></li>
					<li onclick="update_account_modal();" ><i style="color:goldenrod;" class="fas fa-user-edit"></i> <section>Edit</section></li>
					<li onclick="delete_account();" ><i style="color:red;" class="fas fa-user-minus"></i> <section>Delete</section></li>
					<li onclick="insert_invoice_modal('Sale');" ><i style="color:green;" class="fas fa-shopping-cart"></i> <section>Sale</section></li>
					<li onclick="insert_invoice_modal('R Sale');"><i style="color:green;" class="fas fa-file-invoice"></i> <section>R Sale</section></li>
					<li onclick="insert_income_modal('Income');"><i style="color:green;" class="fas fa-file-invoice"></i> <section>Income</section></li>
					<li onclick="insert_payment_modal('Receipt');" ><i style="color:green;" class="fas fa-receipt"></i> <section>Receipt</section></li>
					<li onclick="insert_invoice_modal('Purchase');" ><i style="color:red;" class="fas fa-shopping-cart"></i> <section>Purchase</section></li>
					<li onclick="insert_invoice_modal('R Purchase');" ><i style="color:red;" class="fas fa-file-invoice"></i> <section>R Purchase</section></li>
					<li onclick="insert_income_modal('Outcome');"><i style="color:red;" class="fas fa-file-invoice"></i> <section>Outcome</section></li>
					<li onclick="insert_payment_modal('Payment');" ><i style="color:red;" class="fas fa-receipt"></i> <section>Payment</section></li>
					<li onclick="window.open('php/export.php?accounts=', '_blank');" ><i style="color:yellow;" class="fas fa-save"></i> <section>Export</section></li>
					
				</ul>
				
			</div>
		<!--end menu-->

		<!--item container-->
			<div class="item-container">

				<!--search-bar-->
				<div class="search-bar">

					<input type="text" class="search-input-branch" placeholder="Branch">
					<input type="text" class="search-input-account" placeholder="Account">
					<select class="search-input-type">
						<option disabled>--By Type</option>
						<option value="">All</option>
						<option value="Customer">Customer</option>
						<option value="Supplier">Supplier</option>
						<option value="Expense">Expense</option>
						<option value="Petty Cash">Petty Cash</option>
						<option value="Bank">Bank</option>
						<option value="Sale">Sale</option>
						<option value="Purchase">Purchase</option>
						<option value="Basic">Basic</option>
					</select>
					<select class="search-input-order">
						<option disabled>--Order By Balance</option>
						<option value="DESC">Desc</option>
						<option value="ASC">Asc</option>
					</select>
					<i class="fas fa-search" 
					onclick="
					loader_show();
					
					document.getElementsByClassName('page-search-branch')[0].value =document.getElementsByClassName('search-input-branch')[0].value;
					document.getElementsByClassName('page-search-account')[0].value =document.getElementsByClassName('search-input-account')[0].value;
					document.getElementsByClassName('page-search-type')[0].value =document.getElementsByClassName('search-input-type')[0].value;
					document.getElementsByClassName('page-search-order')[0].value =document.getElementsByClassName('search-input-order')[0].value;
					
					document.getElementsByClassName('page-number')[0].value =0;
					document.getElementsByClassName('items-body')[0].innerHTML ='';
					accounts_body();
					"
					></i>

				</div>
				<!--end search-bar-->

				<div class="items-body"></div>
				<input type="hidden" class="page-number" value="0">
				
				<input type="hidden" class="page-search-branch" value="">
				<input type="hidden" class="page-search-account" value="">
				<input type="hidden" class="page-search-type" value="">
				<input type="hidden" class="page-search-order" value="">
		
			</div>
		<!--end item container-->

		<!--nav-bar-->
			<div class="nav-bar">

				<i onclick="loader_show();window.location='accounts.php';" class="fas fa-user active"></i>
				<i onclick="loader_show();window.location='stock.php';" class="fas fa-cube"></i>
				<i onclick="loader_show();window.location='invoices.php';" class="fas fa-shopping-cart"></i>
				<i onclick="loader_show();window.location='payments.php';" class="fas fa-receipt"></i>
				<i onclick="loader_show();window.location='journal.php';" class="fas fa-book"></i>
				
				<section onclick="loader_show();window.location='accounts.php';" class="active">Accounts</section>
				<section onclick="loader_show();window.location='stock.php';" >Stock</section>
				<section onclick="loader_show();window.location='invoices.php';" >Invoices</section>
				<section onclick="loader_show();window.location='payments.php';" >Payments</section>
				<section onclick="loader_show();window.location='journal.php';">Journal</section>
				
			</div>
		<!--end nav-bar-->
	</div>
<!--end main-container -->

<script src="LeafLet/leaflet.js"></script>
<script src="javascript/jquery.min.js"></script>
<script src="javascript/ajax_get.js"></script>
<script src="javascript/ajax_post.js"></script>
<script src="javascript/main.js"></script>

</body>
</html>