$(function(){
	$('.carousel').carousel('cycle');
    $('.gallery-masonry').masonry({
      itemSelector: '.item',
      isAnimated: true,
      isFitWidth: true
    });    
    
});

function do_stuff() {
	  if (prompt("Are you sure?")) {
	    document.forms[0].submit();
	  } else {
	    alert("hello");
	  }
	  return false;
	}