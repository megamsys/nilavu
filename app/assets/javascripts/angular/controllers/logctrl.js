function LogCtrl($scope, socket, $location, LogStackLimit) {
        $scope.logs = [];
        $scope.total = 0;
        $scope.l_total = 0;
        $scope.prog_bar = "visibility:hidden";
        $scope.bookName = "Select one App/Service..";
        $scope.sendmessage = function(data) {
                $scope.prog_bar = "";
                $scope.logs = [];
                $scope.bookName = data;                        
                socket.emit('message', data);
        };

        socket.on('connect', function(data) {
        });
        
        socket.on('disconnect', function(event) {        	
                socket.disconnect();
        });

        socket.on('message', function(message) {
                $scope.prog_bar = "visibility:hidden";
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
};

/*
* function MyCtrl($scope) { $scope.logs = {}; socket.on('connect',
* function(data) {
*
* });
*
* socket.on('disconnect', function(event) { socket.removeAllListeners();
* alert("disconnect"); });
*
* socket.on('message', function(message) { alert(message.name);
* $scope.logs[message.name] = []; var replaceChar = message.logs.replace(/\@/g,
* ""); var parse = JSON.parse(replaceChar); $scope.source = parse.source;
* $scope.logs[message.name].push(parse); predicate = 'timestamp';
* alert(logs[message.name].message); });
*
* $scope.tabManager = {};
*
* $scope.tabManager.tabItems = [];
*
* $scope.tabManager.checkIfMaxTabs = function(){ var max = 4; var i =
* $scope.tabManager.tabItems.length; if(i > max){ return true; } return false; };
*
* $scope.tabManager.getTitle = function(tabInfo){ console.log("[ title ] ->
* ",tabInfo.title); tabInfo.title.substr(0,10); };
*
* $scope.tabManager.resetSelected = function(){
* angular.forEach($scope.tabManager.tabItems, function(pane) { pane.selected =
* false; }); };
*
*
* $scope.tabManager.addTab = function(node){
* alert($scope.tabManager.tabItems.length);
* if($scope.tabManager.checkIfMaxTabs()){ alert("[Max Tabs] You have opened max
* tabs for this page."); return; } $scope.tabManager.resetSelected(); var i =
* ($scope.tabManager.tabItems.length +1); $scope.tabManager.tabItems.push({
* title: node, selected: true });
* };
*
* //to select the tab $scope.tabManager.select = function(i) {
* angular.forEach($scope.tabManager.tabItems, function(tabInfo) {
* tabInfo.selected = false; }); $scope.tabManager.tabItems[i].selected = true; }
*
*
* //add few tabs /* for(var i = 1; i < 2; i++){
* $scope.tabManager.tabItems.push({ title: "Tab No: " + i, selected: false }); }
*/

// init the first active tab
// $scope.tabManager.select(0);
// };


