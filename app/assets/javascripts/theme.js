jQuery(function () {
    jQuery(window).scroll(function(){
        // add navbar opacity on scroll
        if (jQuery(this).scrollTop() > 100) {
            jQuery(".navbar.navbar-fixed-top").addClass("scroll");
        } else {
            jQuery(".navbar.navbar-fixed-top").removeClass("scroll");
        }

        // global scroll to top button
        if (jQuery(this).scrollTop() > 300) {
            jQuery('.scrolltop').fadeIn();
        } else {
            jQuery('.scrolltop').fadeOut();
        }        
    });


// Grab all elements with the class "hasTooltip"
/*
$('.hasTooltip').each(function() { // Notice the .each() loop, discussed below
    $(this).qtip({
        content: {
            text: $(this).next('div') // Use the "div" element next to this for the content
        }
    });
});
*/


/*
 $(document).ready(function()
 {
     // MAKE SURE YOUR SELECTOR MATCHES SOMETHING IN YOUR HTML!!!
     $('a').qtip({
         // Your config here
     });
     $('input').qtip({
         // Your config here
     });
 });
*/

    // scroll back to top btn
    jQuery('.scrolltop').click(function(){
        jQuery("html, body").animate({ scrollTop: 0 }, 700);
        return false;
    });
    
    // scroll navigation functionality
    jQuery('.scroller').click(function(){
    	var section = jQuery(jQuery(this).data("section"));
    	var top = section.offset().top;
        jQuery("html, body").animate({ scrollTop: top }, 700);
        return false;
    });

    // FAQs
    var jQueryfaqs = jQuery("#faq .faq");
    jQueryfaqs.click(function () {
        var jQueryanswer = jQuery(this).find(".answer");
        jQueryanswer.slideToggle('fast');
    });

    if (!jQuery.support.leadingWhitespace) {
        //IE7 and 8 stuff
        jQuery("body").addClass("old-ie");
    }
});



