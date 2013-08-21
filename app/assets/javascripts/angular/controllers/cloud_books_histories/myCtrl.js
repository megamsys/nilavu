function MyCtrl($scope, socket) {
    socket.on('message', function(data) {
       
    });

    $scope.$on('$destroy', function (event) {
        socket.removeAllListeners();
        // or something like
        // socket.removeListener(this);
    });
};