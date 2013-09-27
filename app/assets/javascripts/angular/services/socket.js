app.factory('socket', function ($rootScope) {
  var socket = io.connect('http://nodejs1.megam.co.in:8000/'), disconnecting = false;
  return {
    on: function (eventName, callback) {
      socket.on(eventName, function () {  
        var args = arguments;
        $rootScope.$apply(function () {
          callback.apply(socket, args);
        });
      });
    },
    emit: function (eventName, data, callback) {
      socket.emit(eventName, data, function () {
        var args = arguments;
        $rootScope.$apply(function () {
          if (callback) {
            callback.apply(socket, args);
          }
        });
      })
    },
    disconnect: function () {
        disconnecting = true;
        socket.disconnect();
      },
      socket: socket
    };  
});
