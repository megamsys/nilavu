<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8 no-js"> <![endif]-->
<!--[if IE 9]> <html lang="en" class="ie9 no-js"> <![endif]-->
<!--[if !IE]><!--> <html lang="en" class="no-js"> <!--<![endif]-->
<!-- BEGIN HEAD -->
<head>
   <meta charset="utf-8" />
   <title>Dashboard | </title>
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <meta content="width=device-width, initial-scale=1.0" name="viewport" />
   <meta content="" name="description" />
   <meta content="" name="author" />
   <meta name="MobileOptimized" content="320">
   <!-- BEGIN GLOBAL MANDATORY STYLES -->          
   <link href="assets/plugins/font-awesome-latest/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>
   <link href="assets/plugins/bootstrap/css/bootstrap.css" rel="stylesheet" type="text/css"/>
   <link href="assets/plugins/uniform/css/uniform.default.css" rel="stylesheet" type="text/css"/>
   <!-- END GLOBAL MANDATORY STYLES -->
 
   <!-- BEGIN THEME STYLES --> 
   <link href="assets/css/custom.css" rel="stylesheet" type="text/css"/>
   <link href="assets/css/megam.css" rel="stylesheet" type="text/css"/>
   <link href="assets/css/style.css" rel="stylesheet" type="text/css"/>
   <link href="assets/css/style-elegant.css" rel="stylesheet" type="text/css"/>
   <link href="assets/css/bootstrap-tour.css" rel="stylesheet">
   <link href="assets/css/component.css" rel="stylesheet">
   <link href="assets/css/presignup.css" rel="stylesheet">
   <link href="assets/css/flags.css" rel="stylesheet">

   <!-- END THEME STYLES -->
   <link rel="stylesheet" href="assets/plugins/faq/css/reset.css"> <!-- CSS reset -->
   <link rel="stylesheet" href="assets/plugins/faq/css/style.css"> <!-- Resource style -->
</head>
<!-- END HEAD -->
<!-- BEGIN BODY -->
<body>
	<!-- BEGIN HEADER -->   
   	<div class="header navbar navbar-fixed-top">
   		<div class="container">
	<?php include('includes/nav.php') ?>
		<!-- BEGIN TOP NAVIGATION BAR -->
		<div class="header-inner">
		<div class="row">
		<div class="col-lg-2 col-md-2 col-sm-3 col-xs-5">
		 	<!-- BEGIN LOGO -->  
			 <a class="navbar-brand" href="index.html">
			 <img src="assets/img/dash-logo.png" alt="logo" class="img-responsive" />
			 </a>
			 <!-- END LOGO -->
		</div>	 

		<div class="col-lg-3 col-md-3 col-sm-3 col-xs-6 col-lg-offset-7 col-md-offset-7 col-sm-offset-6">
			<div class="row">
				 <!-- <div class="col-xs-4 col-sm-1"> -->
					 <ul class="nav navbar-nav pull-right">
					    <!-- BEGIN NOTIFICATION DROPDOWN -->
					    <li class="dropdown" id="header_notification_bar">
					       <a href="#" class="dropdown-toggle" data-toggle="dropdown" data-hover="dropdown"
					          data-close-others="true">
					       <i class="c_glob glyphicon glyphicon-user"></i>
					       <!-- <span class="badge badge-success">6</span> -->
					       </a>
					       <ul class="dropdown-menu extended notification">
					          <li>
					             <ul class="dropdown-menu-list scroller">
					                <li>  
					                   <a href="#">
					                   <span class="label label-sm label-icon label-success"><i class="glyphicon glyphicon-user"></i></span>
					                   Profile 
					                   </a>
					                </li>
					                <li>  
					                   <a href="#">
					                   <span class="label label-sm label-icon label-success"><i class="glyphicon glyphicon-cog"></i></span>
					                   Settings 
					                   </a>
					                </li>
					                <li>  
					                   <a href="#">
					                   <span class="label label-sm label-icon label-danger"><i class="glyphicon glyphicon-off"></i></span>
					                   Logout 
					                   </a>
					                </li>
					             </ul>
					          </li>
					       </ul>
					    </li>
					    <!-- END NOTIFICATION DROPDOWN -->
					</ul>
				<!-- </div>
				<div class="col-xs-4 col-sm-1">	 -->
					 <ul class="nav navbar-nav pull-right m10">
					    <!-- BEGIN NOTIFICATION DROPDOWN -->
					    <li class="dropdown" id="header_notification_bar">
					       <a href="#" class="dropdown-toggle" data-toggle="dropdown" data-hover="dropdown"
					          data-close-others="true">
					       <i class="fa fa-bell"></i>
					       <span class="badge badge-success">6</span>
					       </a>
					       <ul class="dropdown-menu extended notification">
					          <li>
					             <p>You have 14 new notifications</p>
					          </li>
					          <li>
					             <ul class="dropdown-menu-list scroller">
					                <li>  
					                   <a href="#">
					                   <span class="label label-sm label-icon label-success"><i class="icon-plus"></i></span>
					                   New user registered. 
					                   <span class="time">Just now</span>
					                   </a>
					                </li>
					                <li>  
					                   <a href="#">
					                   <span class="label label-sm label-icon label-danger"><i class="icon-bolt"></i></span>
					                   Server #12 overloaded. 
					                   <span class="time">15 mins</span>
					                   </a>
					                </li>
					             </ul>
					          </li>
					          <li class="external">   
					             <a href="#">See all notifications <i class="m-icon-swapright"></i></a>
					          </li>
					       </ul>
					    </li>
					    <!-- END NOTIFICATION DROPDOWN -->
					</ul>
				<!-- </div>
				<div class="col-xs-4 col-sm-1"> -->
					 <!-- BEGIN RESPONSIVE MENU TOGGLER --> 
					 <a href="javascript:;" class="navbar-toggle collapsed pull-right" data-toggle="collapse" data-target=".navbar-collapse">
					 <img src="assets/img/menu-toggler.png" alt="" />
					 </a> 
					 <!-- END RESPONSIVE MENU TOGGLER -->
				 <!-- </div> -->
			</div>	
		</div>

		</div>	 
		</div>
		<!-- END TOP NAVIGATION BAR -->
		</div>
	</div>
		<!-- END HEADER -->