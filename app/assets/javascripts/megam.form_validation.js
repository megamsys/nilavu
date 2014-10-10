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

