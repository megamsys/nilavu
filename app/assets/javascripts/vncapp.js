/* global Screen, Client */
(function () {
  'use strict';
  var client;

$("#vncid").on('click', function(evt) {
  var href = $(this).attr('href');
    vncopen(href);
  });


function vncopen(vncurl) {
var form = document.createElement("form");
document.body.appendChild(form);
form.method = "POST";
form.action =  "http://"+vncurl+":8090/vnc "  ;
form.target = "_blank";
var element1 = document.createElement("INPUT");
element1.name="host"
element1.value = $('#vncHost').attr('value');
element1.type = 'hidden'
form.appendChild(element1);
var element2 = document.createElement("INPUT");
element2.name="port";
element2.value = $('#vncPort').attr('value') ;
element2.type = 'hidden'
form.appendChild(element2);
form.submit();

}

}());
