app.factory('UpdateWidget', function($rootScope) {
    //var sharedService = {};
    
    message = '';

    prepForBroadcast = function(msg) {
        this.message = msg;
        broadcastItem();
    };

    broadcastItem = function() {
        $rootScope.$broadcast('handleBroadcast');
    };

    return {
    	prepForBroadcast: prepForBroadcast
      };
});