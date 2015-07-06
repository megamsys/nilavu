app.factory (' Socket ', [' $rootScope ', function ($rootScope) {
    var connections = {};//a pool of joints, each of which forms on demand
 
    function getConnection (channel) {
        if (! connections [channel]) {
            connections [channel] = io.connect ($.SocketURL + channel);
        }
 
        return connections [channel];
    }
 
    //At creation of a new socket, it is initialized by a namespace-part of a line of connection.
    function Socket (namespace) {
        this.namespace = namespace;
    }
 
    Socket.prototype.on = function (eventName, callback) {
        var con = getConnection (this.namespace), self = this;//obtaining or creation of the new joint
        con.on (eventName, function () {
            var args = arguments;
            $rootScope. $ apply (function () {callback.apply (con, args);});
        });
    };
 
    Socket.prototype.emit = function (eventName, data, callback) {
        var con = getConnection (this.namespace);//obtaining or creation of the new joint.
        con.emit (eventName, data, function () {
            var args = arguments;
            $rootScope. $ apply (function () {if (callback) {callback.apply (con, args);}});
        })
    };
 
    return Socket;
}]);
