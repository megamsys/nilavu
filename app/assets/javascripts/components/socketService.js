'use strict';


function SocketService() {
console.log("inside socketservice");
	var service = {};


	function init() {
		service = {};

	}

console.log("init-->");
	init();

	function sendRequest() {
    console.log("initzz===================23411======");
	//	React.findDOMNode(io).connect('http://localhost:7000');

   //var socket = io('http://localhost:7000');
  //	  console.log(socket);

    //socket.on('connect', function() {});
    console.log("asdsdsdsdsdsdsdsddsdsdsd");
		}


	service.sendRequest = sendRequest;
//	service.requestComplete = requestComplete;
//	service.stopRequest = stopRequest;
	return service;

}
