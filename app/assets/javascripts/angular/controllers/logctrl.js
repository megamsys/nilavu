/*
** Copyright [2013-2015] [Megam Systems]
**
** Licensed under the Apache License, Version 2.0 (the "License");
** you may not use this file except in compliance with the License.
** You may obtain a copy of the License at
**
** http://www.apache.org/licenses/LICENSE-2.0
**
** Unless required by applicable law or agreed to in writing, software
** distributed under the License is distributed on an "AS IS" BASIS,
** WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
** See the License for the specific language governing permissions and
** limitations under the License.
*/
app.controller("LogCtrl", ["$scope", "socket", "$location", "$rootScope", "LogStackLimit",

function($scope, socket, $location,  $rootScope, LogStackLimit) {
    $scope.logs = [];
    $scope.total = 0;
    $scope.l_total = 0;
    $scope.bookName = "";
    $scope.spinneractive = true;
    $scope.listOfOptions = $scope.books;

  $scope.selectedItemChanged = function(){
    $scope.calculatedValue = 'You selected number ' + $scope.selectedItem;
  };

    $scope.sendmessage = function(data) {
        $scope.logs = [];
        $scope.bookName = data;
        socket.emit('message', data);
    };

    socket.on('connect', function(data) {
        console.log("connected successfully");
    });

    socket.on('disconnect', function(event) {
        socket.disconnect();
    });

    socket.on('message', function(message) {
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

    });

    $scope.book_json = 'http://mob.co/kibana/#/dashboard/.json';
}]);
