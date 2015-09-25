$('.inner-menu').click(function(e) {
    e.preventDefault();
    $('.inner-child').toggle();
});


//stoarge left menu
$('.storage_left_add_inner').hide();
$('.storage_left_add a ').click( function(){
    // e.preventDefault();
     $('.storage_left_add_inner').slideToggle();
});
// grid/list
$('#app-list').hide();

$('#app-list-btn').on('click', function(){
    $('#app-grid').hide();
    $('#app-list').show();

});

$('#app-grid-btn').on('click', function(){
    $('#app-list').hide();
    $('#app-grid').show();

});

$(window).on('resize', function() {

    if ( $(window).width()  < 480) {

        $('#app-list').hide();
        $('#app-grid').show();
    };
});

$('#mp').on('hover', function() {

    $('#mp i').toggleClass('c_icon-window-lg');
    $('#mp i').toggleClass('c_icon-window-lg-sel');
    $('#mp span').toggleClass('mplace-selected');
});
$('#stor').on('hover', function() {

    $('#stor i').toggleClass('c_icon-grid-hover');
    $('#stor i').toggleClass('c_icon-grid-25');
    // $('#stor i').toggleClass('c_icon-grid');
    $('#stor span').toggleClass('mplace-selected');
});
