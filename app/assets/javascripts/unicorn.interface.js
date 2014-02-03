/**
 * Unicorn Admin Template
 * Version 2.2.0
 * Diablo9983 -> diablo9983@gmail.com
**/

$(document).ready(function(){
		
	
    $('#bootbox-confirm').click(function(e){
    	e.preventDefault();
    	bootbox.confirm("Are you sure?", function(result) {
    		var msg = '';
    		if(result == true) {
    			msg = 'Yea! You confirmed this.';
    		} else {
    			msg = 'Not confirmed. Don\'t worry.';
    		}
			bootbox.dialog({
				message: msg,
				title: 'Result',
				buttons: {
					main: {
						label: 'Ok',
						className: 'btn-default'
					}
				}
			});
		}); 
    });
    $('#bootbox-prompt').click(function(e){
    	e.preventDefault();
    	bootbox.prompt("What is your name?", function(result) {
			if (result !== null && result !== '') {
				bootbox.dialog({
					message: 'Hi '+result+'!',
					title: 'Welcome',
					buttons: {
						main: {
							label: 'Close',
							className: 'btn-danger'
						}
					}
				});
			}
		});
    });
    $('#bootbox-alert').click(function(e){
    	e.preventDefault();
    	bootbox.alert('Hello World!');
    });
    
});
