app.controller("LogCtrl", ["$scope", "socket", "$location", "usSpinnerService", "$rootScope", "LogStackLimit",

function($scope, socket, $location, usSpinnerService, $rootScope, LogStackLimit) {
    $scope.logs = [];
    $scope.total = 0;
    $scope.l_total = 0;
    $scope.bookName = "";
    $scope.spinneractive = false;
    $scope.listOfOptions = $scope.books;

  $scope.selectedItemChanged = function(){
    $scope.calculatedValue = 'You selected number ' + $scope.selectedItem;
  };   
    
    $scope.sendmessage = function(data) {
    console.log("=================================");
        if (!$scope.spinneractive) {
            usSpinnerService.spin('spinner-1');
        }
        $scope.logs = [];
        $scope.bookName = data;
        socket.emit('message', data);
        if ($scope.spinneractive) {
            usSpinnerService.stop('spinner-1');
        }
    };

    $rootScope.$on('us-spinner:spin', function(event, key) {
        $scope.spinneractive = true;
    });

    $rootScope.$on('us-spinner:stop', function(event, key) {
        $scope.spinneractive = false;
    });

    socket.on('connect', function(data) {
        console.log("connected successfully");
    });

    socket.on('disconnect', function(event) {
        socket.disconnect();
    });

    socket.on('message', function(message) {
        if (!$scope.spinneractive) {
            usSpinnerService.spin('spinner-1');
        }
        $scope.total = $scope.total + 1;
        $scope.l_total = $scope.l_total + 1;
        var replaceChar = message.logs.replace(/\@/g, "");
        var parse = JSON.parse(replaceChar);
        $scope.source = parse.source;
        $scope.logs.push(LogStackLimit.push(parse));
        if ($scope.total > 100) {
            $scope.logs = [];
            $scope.total = 0;
        }
        predicate = 'timestamp';
        if ($scope.spinneractive) {
            usSpinnerService.stop('spinner-1');
        }
    });

    $scope.book_json = 'http://mob.co/kibana/#/dashboard/.json';
}]);
