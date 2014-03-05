$(function(){
	$('.carousel').carousel('cycle');
    $('.gallery-masonry').masonry({
      itemSelector: '.item',
      isAnimated: true,
      isFitWidth: true
    });    
    
});

