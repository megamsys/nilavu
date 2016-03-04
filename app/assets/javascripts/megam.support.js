//These are helper functions used by the UI
function removeAt(selector_to_remove) {
  $(selector_to_remove).remove();
}

function insertAt(location, content_to_insert) {
  $(location).html(content_to_insert);
}

function repWith(location, content_to_replace) {
  $(location).replaceWith(content_to_replace);
}
//end helper functions.
