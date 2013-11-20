app.factory('UpdateWidget', function($rootScope) {
    //var sharedService = {};
    
    message = '';
    sm = true;

    prepForBroadcast = function(msg) {    	
        this.message = msg;
        broadcastItem();
    };

    showForBroadcast = function(msg) {    	
        this.sm = msg;
        broadcastItem();
    };
    
    broadcastItem = function() {
        $rootScope.$broadcast('handleBroadcast');       
    };

    return {
    	prepForBroadcast: prepForBroadcast,
    	showForBroadcast: showForBroadcast
      };
});