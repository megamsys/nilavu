/**
 * Unicorn Admin Template
 * Version 2.0.2
 * Diablo9983 -> diablo9983@gmail.com
**/

$(document).ready(function(){

	var login = $('#loginform');
	var recover = $('#recoverform');
    var register = $('#registerform');
    var login_recover = $('#loginform, #recoverform');
    var login_register = $('#loginform, #registerform');
    var recover_register = $('#recoverform, #registerform');
    var loginbox = $('#loginbox');
	var speed = 300;

	$('.flip-link.to-recover').click(function(){
		login_register.css('z-index','100').fadeTo(speed,0.01,function(){
            loginbox.animate({'height':'173px'},speed,function(){
                recover.fadeTo(speed,1).css('z-index','200');
            });
        });
	});
	$('.flip-link.to-login').click(function(){
		recover_register.css('z-index','100').fadeTo(speed,0.01,function(){
            loginbox.animate({'height':'255px'},speed,function(){
                login.fadeTo(speed,1).css('z-index','200');
            });
        });
	});
    $('.flip-link.to-register').click(function(){
        login_recover.css('z-index','100').fadeTo(speed,0.01,function(){
            loginbox.animate({'height':'270px'},speed,function(){
                register.fadeTo(speed,1).css('z-index','200');
            });
        });
    });
    
    if($.browser.msie == true && $.browser.version.slice(0,3) < 10) {
        $('input[placeholder]').each(function(){            
            var input = $(this);     
            $(input).val(input.attr('placeholder'));                   
            $(input).focus(function(){
                 if (input.val() == input.attr('placeholder')) {
                     input.val('');
                 }
            });           
            $(input).blur(function(){
                if (input.val() == '' || input.val() == input.attr('placeholder')) {
                    input.val(input.attr('placeholder'));
                }
            });
        });       
    }
});