$(function(){	
	$('.carousel').carousel('cycle');
    $('.gallery-masonry').masonry({
      itemSelector: '.item',
      isAnimated: true,
      isFitWidth: true
    });      

});

$(function(){
    
	  var $container = $('#iso_container'),
	      filters = {};

	  $container.isotope({
	    itemSelector : '.produkt-element',
	    layoutMode: 'fitRows'
	    		});

	  // filter buttons
	  $('#filters select').change(function(){
	    var $this = $(this);
	    
	    // store filter value in object
	    // i.e. filters.color = 'red'
	    var group = $this.attr('data-filter-group');
	    filters[ group ] = $this.find(':selected').attr('data-filter-value');
	    // console.log( $this.find(':selected') )
	    // convert object into array
	    var isoFilters = [];
	    for ( var prop in filters ) {
	      isoFilters.push( filters[ prop ] )
	    }
	    var selector = isoFilters.join('');
	    $container.isotope({ filter: selector });
	    return false;
	  });	  
	 

	});

$(document).ready(function() {	
	
	$('#app_version').change(function(){		
	      $.ajax({url: '/changeversion',
	    	'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")},
	        data: 'version='+$(this).find("option:selected").text()+':'+$("#marketplace_name").val()	        
	      })
	    });				 
});


