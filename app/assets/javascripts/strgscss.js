$(document).ready(function() {
$('.inner-menu').click(function(e) {
    e.preventDefault();
    $('.inner-child').toggle();
});

$('.create_bucket_modal').click( function(e){
  $('#create_bucket').show();
});
//storage left menu
$('.storage_left_add_inner').hide();
$('.storage_left_add a ').click( function(){
    // e.preventDefault();
     $('.storage_left_add_inner').slideToggle();
});

// $('.storage-popup').hide();
// storage overview pop up menu
$('.my_bucket_inner').click(function(e){

    $('.storage-popup').css({'top':e.pageY,'left':e.pageX, });
    $('.storage-popup').show();
});

// hide storage menu when clicked outside the div
$(document).on('click', function (e) {
    if ($(e.target).closest(".my_bucket_inner").length === 0) {
        $('.storage-popup').hide();
    }
});
});
