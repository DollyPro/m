<?php
$hosting_finish_date = new DateTime("2022-09-20");
//Do Not Edit
$date = new DateTime("now", new DateTimeZone('Asia/Beirut') );
$difference = $date->diff($hosting_finish_date);
$days_left = $difference->d + ( $difference->m * 30 ) + ( $difference->y * 365 ) ;
if ( ($date>$hosting_finish_date) ) die("Expired Hosting Plan");
//Do Not Edit
?>