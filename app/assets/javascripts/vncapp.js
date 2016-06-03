/* global Screen, Client */
(function () {
  'use strict';
  var client;

$("#vncid").on('click', function() {
    vncopen();
  });


  function vncopen() {
var form = document.createElement("form");
document.body.appendChild(form);
form.method = "POST";
form.action = "http://192.168.0.106:8090/vnc";
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
