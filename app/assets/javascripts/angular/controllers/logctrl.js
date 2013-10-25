function LogCtrl($scope, socket, $location, LogStackLimit) {	
	$scope.logs = [];
	$scope.total=0;
	$scope.l_total=0;
	$scope.bookName = "Select one book name";
	$scope.sendmessage = function(data) {

		$scope.bookName = data;
		socket.emit('message', data);		
	};
	
	socket.on('connect', function(data) {
        
	});

	socket.on('disconnect', function(event) {
		socket.disconnect();

	});

	socket.on('message', function(message) {	
		$scope.total = $scope.total+1;
		$scope.l_total = $scope.l_total+1;
		var replaceChar = message.logs.replace(/\@/g, "");
		var parse = JSON.parse(replaceChar);		
		$scope.source = parse.source;		
		$scope.logs.push(LogStackLimit.push(parse));
		if($scope.total>100) {
			$scope.logs =[];
			$scope.total = 0;
		}
		predicate = 'timestamp';		
	});
	
	$scope.book_json = 'http://mob.co/kibana/#/dashboard/{'+
		+'"title": "Logstash elastic search",'+
		+'"services": {'+
		+'"query": {'+
		+'"idQueue": ['+
		+'1,'+
		+'2,'+
		+'3,'+
		+'4'+
		+'],'+
		+'"list": {'+
		+'"0": {'+
		+'"query": "",'+
		+'"alias": "",'+
		+'"color": "#7EB26D",'+
		+'"id": 0'+
		+'}'+
		+'},'+
		+'"ids": ['+
		+'0'+
		+']'+
		+'},'+
		+'"filter": {'+
		+'"idQueue": ['+
		+'1,'+
		+'2'+
		+'],'+
		+'"list": {'+
		+'"0": {'+
		+'"from": "2013-07-27T09:37:57.908Z",'+
		+'"to": "2013-07-27T10:37:57.909Z",'+
		+'"field": "@timestamp",'+
		+'"type": "time",'+
		+'"mandate": "must",'+
		+'"active": true,'+
		+'"alias": "",'+
		+'"id": 0'+
		+'}'+
		+'},'+
		+'"ids": ['+
		+'0'+
		+']'+
		+'}'+
		+'},'+
		+'"rows": ['+
		+'{'+
		+'"title": "Options",'+
		+'"height": "50px",'+
		+'"editable": true,'+
		+'"collapse": false,'+
		+'"collapsable": true,'+
		+'"panels": ['+
		+' {'+
		+'  "error": "",'+
		+'"span": 6,'+
		+'"editable": true,'+
		+'"group": ['+
		+'"default"'+
		+'],'+
		+'"type": "timepicker",'+
		+'"status": "Stable",'+
		+'"mode": "relative",'+
		+'"time_options": ['+
		+'"5m",'+
		+'"15m",'+
		+'"1h",'+
		+'"6h",'+
		+'"12h",'+
		+'"24h",'+
		+'"2d",'+
		+'"7d",'+
		+'"30d"'+
		+'],'+
		+'"timespan": "1h",'+   
		+'"timefield": "@timestamp",'+
		+'"timeformat": "",'+
		+'"refresh": {'+
		+'"enable": false,'+
		+'"interval": 10,'+
		+'"min": 3'+
		+'},'+
		+'"filter_id": 0,'+
		+'"status": "Stable"'+
		+'}'+
		+']'+
		+'},'+
		+'{'+
		+'"title": "Query",'+
		+'"height": "50px",'+
		+'"editable": true,'+
		+'"collapse": false,'+
		+'"collapsable": true,'+
		+'"panels": ['+
		+'{'+
		+'"error": false,'+
		+'"span": 12,'+
		+'"editable": true,'+
		+'"group": ['+
		+'"default"'+
		+'],'+
		+'"type": "query",'+
		+'"label": "Search",'+
		+'"query": "*",'+
		+'"history": [],'+
		+'"remember": 10,'+
		+'"pinned": true'+
		+'}'+
		+']'+
		+'},'+
		+'{'+
		+'"title": "Filters",'+
		+'"height": "50px",'+
		+'"editable": true,'+
		+'"collapse": true,'+
		+'"collapsable": true,'+
		+'"panels": ['+
		+'{'+
		+'"loading": false,'+
		+'"error": false,'+
		+'"span": 12,'+
		+'"editable": true,'+
		+'"group": ['+
		+'"default"'+
		+'],'+
		+'"type": "filtering",'+
		+'"status": "Experimental"'+
		+'}'+
		+']'+
		+'},'+
		+'{'+
		+'"title": "Graph",'+
		+'"height": "350px",'+
		+'"editable": true,'+
		+'"collapse": false,'+
		+'"collapsable": true,'+
		+'"panels": ['+
		+'{'+
		+'"loading": false,'+
		+'"span": 12,'+
		+'"editable": true,'+
		+'"group": ['+
		+'"default"'+
		+'],'+
		+'"type": "histogram",'+
		+'"status": "Stable",'+
		+'"query": ['+
		+'{'+
		+'"query": "*",'+
		+'"label": "Query"'+
		+'}'+
		+'],'+
		+'"mode": "count",'+
		+'"time_field": "@timestamp",'+
		+'"value_field": null,'+
		+'"auto_int": true,'+
		+'"resolution": 100,'+
		+'"interval": "30s",'+
		+'"fill": 3,'+
		+'"linewidth": 3,'+
		+'"timezone": "browser",'+
		+'"spyable": true,'+
		+'"zoomlinks": true,'+
		+'"bars": true,'+
		+'"stack": true,'+
		+'"points": false,'+
		+'"lines": false,'+
		+'"legend": true,'+
		+'"x-axis": true,'+
		+'"y-axis": true,'+
		+'"percentage": false,'+
		+'"interactive": true,'+
		+'"queries": {'+
		+'"mode": "all",'+
		+'"ids": ['+
		+'0'+
		+']'+
		+'}'+
		+'}'+
		+']'+
		+'},'+
		+'{'+
		+'"title": "Map",'+
		+'"height": "500px",'+
		+'"editable": true,'+
		+'"collapse": false,'+
		+'"collapsable": true,'+
		+'"panels": ['+
		+'{'+
		+'"loading": false,'+
		+'"error": false,'+
		+'"span": 12,'+
		+'"editable": true,'+
		+'"group": ['+
		+'"default"'+
		+'],'+
		+'"type": "map",'+
		+'"queries": {'+
		+'"mode": "all",'+
		+'"ids": ['+
		+'0'+
		+']'+
		+'},'+
		+'"size": 1000,'+
		+'"spyable": true,'+
		+'"tooltip": "_id",'+
		+'"field": "@collectorData.geo.country",'+
		+'"title": "Rule the world",'+
		+'"map": "world",'+
		+'"colors": ['+
		+'"#A0E2E2",'+
		+'"#265656"'+
		+'],'+
		+'"exclude": [],'+
		+'"index_limit": 0'+
		+'}'+
		+']'+
		+'},'+
		+'{'+
		+'"title": "Events",'+
		+'"height": "350px",'+
		+'"editable": true,'+
		+'"collapse": false,'+
		+'"collapsable": true,'+
		+'"panels": ['+
		+' {'+
		+'"error": false,'+
		+'"span": 12,'+
		+'"editable": true,'+
		+'"group": ['+
		+'"default"'+
		+'],'+
		+'"type": "table",'+
		+'"size": 100,'+
		+'"pages": 5,'+
		+'"offset": 0,'+
		+'"sort": ['+
		+'"@timestamp",'+
		+'"desc"'+
		+'],'+
		+'"style": {'+
		+'"font-size": "9pt"'+
		+'},'+
		+'"overflow": "min-height",'+
		+'"fields": [],'+
		+'"highlight": [],'+
		+'"sortable": true,'+
		+'"header": true,'+
		+'"paging": true,'+
		+'"spyable": true,'+
		+'"queries": {'+
		+'"mode": "all",'+
		+'"ids": ['+
		+'0'+
		+']'+
		+'},'+
		+'"field_list": true,'+
		+'"status": "Stable"'+
		+'}'+
		+']'+
		+'}'+
		+'],'+
		+'"editable": true,'+
		+'"index": {'+
		+'"interval": "none",'+
		+'"pattern": "[logstash-]YYYY.MM.DD",'+
		+'"default":'+ $scope.bookName +
		+'}'+
		+'}.json';
	};
	
	
	







/*function MyCtrl($scope) {	
	$scope.logs = {};
	socket.on('connect', function(data) {
        
	});

	socket.on('disconnect', function(event) {
		socket.removeAllListeners();
		alert("disconnect");	
	});

	socket.on('message', function(message) {	
		alert(message.name);	
		$scope.logs[message.name] = [];
		var replaceChar = message.logs.replace(/\@/g, "");
		var parse = JSON.parse(replaceChar);		
		$scope.source = parse.source;					
		$scope.logs[message.name].push(parse);
		predicate = 'timestamp';	
		alert(logs[message.name].message);
	});
	
	 $scope.tabManager = {};

	    $scope.tabManager.tabItems = [];
	    
	    $scope.tabManager.checkIfMaxTabs = function(){
	        var max = 4;
	        var i = $scope.tabManager.tabItems.length;
	        if(i > max){
	            return true;
	        }
	        return false;
	    };

	    $scope.tabManager.getTitle = function(tabInfo){
	        console.log("[ title ] -> ",tabInfo.title);
	        tabInfo.title.substr(0,10);
	    };

	    $scope.tabManager.resetSelected = function(){
	        angular.forEach($scope.tabManager.tabItems, function(pane) {
	            pane.selected = false;
	        });
	    };
   
	    
	    $scope.tabManager.addTab = function(node){
	    	alert($scope.tabManager.tabItems.length);
	        if($scope.tabManager.checkIfMaxTabs()){
	            alert("[Max Tabs] You have opened max tabs for this page.");
	            return;
	        }
	        $scope.tabManager.resetSelected();	       
	        	var i = ($scope.tabManager.tabItems.length +1);	        	
		        $scope.tabManager.tabItems.push({
		            title: node,		            
		            selected: true		       
	        });       
	        
	    };
	    
	    //to select the tab
	    $scope.tabManager.select = function(i) {
	        angular.forEach($scope.tabManager.tabItems, function(tabInfo) {
	            tabInfo.selected = false;
	        });
	        $scope.tabManager.tabItems[i].selected = true;
	    }


	    //add few tabs
	   /* for(var i = 1; i < 2; i++){
	        $scope.tabManager.tabItems.push({
	            title: "Tab No: " + i,	            
	            selected: false
	        });
	    }*/
	    
	    // init the first active tab
	    //$scope.tabManager.select(0);
	//};
	


