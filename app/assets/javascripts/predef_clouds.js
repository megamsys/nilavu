$(document).ready(function(){		
	var boo=false;
	var boo1=false;
	$("#new_db1 input:radio").click(function() {
			boo=true;
	  if(boo1){
		$("#db_next").attr("disabled", false); //enable next button
	         }
	});
	$("#new_db2 input:radio").click(function() {
			boo1=true;
	  if(boo){
		$("#db_next").attr("disabled", false); //enable next button
	         }
	});
});


