$(document).ready(function(){
      $("#theform").validate({
         rules: {     
            check_req: {required: true}
         },
         messages: {
            check_req: "Just check the box"
         },
         tooltip_options: {
            check_req: {placement:'right',html:true}
         },
      });
});


$(document).ready( function(){

    $('.app_config').click( function(event){

    	$('.config_menu').hide();
		$('.app_config').removeClass('config_acive');
    	cls = this.id;
    	// $('.app_config').removeClass('config_acive');
        event.stopPropagation();
        $('.'+cls).toggle();
        $(this).toggleClass('config_acive');
    });

    $(document).click( function(){
        $('.config_menu').hide();
        $('.app_config').removeClass('config_acive');
    });
});

// Remove alert message on clicking the close button
$(".c_remove").click(function(){
    $('.c_remove_main').hide();
});


    $(".default .jCarouselLite").jCarouselLite({
        btnNext: ".default .next",
        btnPrev: ".default .prev",
        start: 2,
        scroll: 3
    });

// LOAD cloud-1 by default
$( "#tab_1_1_2" ).load( "cloud-1.php" );


