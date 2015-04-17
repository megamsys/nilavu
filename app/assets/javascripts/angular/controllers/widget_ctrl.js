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
app.controller("WidgetCtrl", ["$scope", "$element", "$timeout", "$rootScope", function($scope, $element, $timeout, $rootScope) {

  var previousData = null;
  var timer = null;
  var abortTimer = false;
  var updateFunction = null;
  var update_interval = 20; 
  $rootScope.$on('$routeChangeStart', function(ngEvent, route) {
    abortTimer = true;
    if (timer) $timeout.cancel(timer);
  });
  
  function onError(response) {
    $scope.showError = true;
    if (response.status === 0) {
      $scope.widget.message = "Could not connect to rails app";
    } else {
      $scope.widget.message = response.data.message;
    }
  }

  function onSuccess(response) {
    $scope.showError = false;

    if (response && response.data) $scope.previousData = response.data;
  }

  function updateTimer() {
    $scope.widget.enableSpinner = false;

    if (!abortTimer) timer = $timeout(startTimer, update_interval * 200);
  }

  function startTimer() {
    $scope.widget.enableSpinner = true;

    var result = updateFunction();
    if (result && result.then) {
     result.then(onSuccess, onError).then(updateTimer);
    } else {
      onSuccess(result);
      updateTimer();
   }
  }
  
  $scope.init = function(updateFn) {
    updateFunction = updateFn;
    startTimer();
  };
  
  function update_widget(source) {
	  if ($scope.widget.widget_type == "pernode") {
		  $scope.widget.$update;
	  }
  }

}]);
