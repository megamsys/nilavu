jQuery(document).ready(function() { 

    // "ajax:beforeSend" and "ajax:complete" event hooks are
    // provided by Rails's jquery-ujs driver.
    jQuery("*[data-spinlock]").on('ajax:beforeSend', function(e) {
        $(this).spin("large", "Black");
        //$('#loading').fadeIn();
        console.log('spinlock started');
        //e.stopPropagation();
    }).on("ajax:success", function(xhr, data, status) {
        console.log('spinlock success');
        return false;
    }).on("ajax:complete", function(xhr, status) {
        $(this).spin(false);
       // $('#loading').fadeOut();
        console.log('spinlock complete');
        return false;
    }).on("ajax:error", function(xhr, status, error) {
        console.log('error ' + error + "status=" + status);
        var errorStr = "An error occurred when the attemping an ajax request. [status :" + xhr.status + ",   Status Text :" + xhr.status + ",   Exception :" + error + "]";
        console.log('Error ' + errorStr + "\n" + xhr.reponseText);
        return false;
    });

});

function removeAt(selector_to_remove) {
    $(selector_to_remove).remove();
    console.log('removed :' + selector_to_remove);
}

function insertAt(location, content_to_insert) {
    $(location).html(content_to_insert);
    console.log('inserted :' + location + ' =>' + content_to_insert);
}

function repWith(location, content_to_replace) {
    $(location).replaceWith(content_to_replace);
    console.log('replaced :' + location + ' =>' + content_to_replace);
}