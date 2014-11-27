app.factory('socket', function($rootScope) {
    // var socket = io.connect('http://redis1.megam.co.in:7000/'), disconnecting = false;
    //  var socket = io.connect('http://megamd.megam.co.in:8000');
    var socket = io.connect($.SocketURL);
    
    return {
        on : function(eventName, callback) {
            socket.on(eventName, function() {
                var args = arguments;
                $rootScope.$apply(function() {
                    callback.apply(socket, args);
                });
            });
        },
        emit : function(eventName, data, callback) {
            socket.emit(eventName, data, function() {
                var args = arguments;
                $rootScope.$apply(function() {
                    if (callback) {
                        callback.apply(socket, args);
                    }
                });
            });
        },
        disconnect : function() {
            disconnecting = true;
            socket.disconnect();
        },
        socket : socket
    };
});

