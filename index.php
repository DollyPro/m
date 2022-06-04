<?php

require 'hosting-plan.php';
require 'php/get.php';

session_start();

$message ='';
$name ='';
$my_password ='';

if ( isset($_GET['sign-out']) ){
	unset($_SESSION['name']);
	unset($_SESSION['password']);
	header('Location:index.php');
	die();
}

if ( isset($_SESSION['name']) && isset($_SESSION['password']) ){

	$name =$_SESSION['name'];
	$my_password =$_SESSION['password'];

	if ( !( $response =check_user( $name, $my_password ) ) ){
		$response['error']= '100000';
		die(json_encode($response));
	}
	
	if ( $response['error']==0 ){
		header('Location:home.php');
		die();
	}
	
	unset($_SESSION['name']);
	unset($_SESSION['password']);
	$message ='<i class="fas fa-exclamation-triangle" style="color:red;margin-top:50px;">Wrong credentials, please try again.</i>';
	
}

if ( isset( $_GET['sign-in'] ) && isset( $_GET['name'] ) && isset( $_GET['password'] ) ){

	$name =$_GET['name'];
	$my_password =$_GET['password'];
	$my_password = hash('sha256', $my_password);

	if ( !( $response =check_user( $name, $my_password ) ) ){
		$response['error']= '100000';
		die(json_encode($response));
	}

	if ( $response['error']==0 ){

		$_SESSION['name'] =$name;
		$_SESSION['password'] =$my_password;
		header('Location:home.php');
		die();
		
	}
	
	$message ='<i class="fas fa-exclamation-triangle" style="color:red;margin-top:50px;">Wrong credentials, please try again.</i>';
	
}

?>
<!doctype html>
<html>
<header>

	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<link rel="stylesheet" href="icons/fontawesome-free-5.12.0-web/css/all.css">
	<link rel="stylesheet" href="bootstrap-4.4.1-dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
	<link rel="stylesheet" href="css/main.css">

</header>
<title>M.Welcome</title>
<body>


<div>

	<div class="logo-big">
		<img src="logo.png" >
	</div>	
	
	<?php echo $message ;?>

	<div class="sign-in-container">
	
	<form class="sign-in" action="index.php" method="GET">

		<input name="sign-in" type="hidden" value="sign-in">
		<input type="submit" value="5" style="display:none;">
		<section>
			<h5>Username:</h5>
			<input name="name" type="text" value="<?php echo $name;?>" >
			<i class="fas fa-user"></i>
		</section>
		
		<section>
			<h5>Password:</h5>
			<input name="password" type="password" >
			<i class="fas fa-key"></i>
		</section>
		
		<h6 class="cookie-alert">This site uses cookies to know who you are, giving you the best possible experience. By continuing to use the site you agree that we can save cookies on your device.</h6>
		
		<section class="action">
			<i class="fas fa-sign-in-alt sign-in-btn"> Sign in</i>
		</section>
	</form>
	
	<div class="sign-in-gif"></div>
	
	</div>

</div>


<script src="javascript/jquery.min.js"></script>
<script src="javascript/ajax_post.js"></script>
<script src="javascript/main.js"></script>

</body>
</html>