/**
  Keep track of when the browser is in focus.
**/
export default {
  name: 'focus-event',

  initialize: function() {
    var hidden = "hidden";

    // Default to true
    Nilavu.set('hasFocus', true);

    var gotFocus = function() {
      if(!Nilavu.get('hasFocus')){
        Nilavu.setProperties({hasFocus: true, notify: false});
      }
    };

    var lostFocus = function() {
      if(Nilavu.get('hasFocus')) {
        Nilavu.set('hasFocus', false);
      }
    };

    var onchange = function(evt) {
        var v = 'visible', h = 'hidden',
            evtMap = {
                focus:v, focusin:v, pageshow:v, blur:h, focusout:h, pagehide:h
            };

        evt = evt || window.event;
        if (evt.type in evtMap){
            if(evtMap[evt.type] === 'hidden') {
              lostFocus();
            } else {
              gotFocus();
            }
        }
        else {
            if(this[hidden]) {
              lostFocus();
            } else {
              gotFocus();
            }
        }
    };

    // from StackOverflow http://stackoverflow.com/a/1060034/17174
    if (hidden in document) {
        document.addEventListener('visibilitychange', onchange);
    }
    else if ((hidden = 'mozHidden') in document) {
        document.addEventListener('mozvisibilitychange', onchange);
    }
    else if ((hidden = 'webkitHidden') in document) {
        document.addEventListener('webkitvisibilitychange', onchange);
    }
    else if ((hidden = 'msHidden') in document) {
        document.addEventListener('msvisibilitychange', onchange);
    }
    // All others (including iPad which is a bit weird and gives onpageshow / hide
    else {
        window.onpageshow = window.onpagehide = window.onfocus = window.onblur = onchange;
    }
  }
};
