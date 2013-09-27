app.directive('pane', function() {
        return {
            require: '^tabs',
            restrict: 'A',
            transclude: true,
            scope: { title: '@' },
            link: function(scope, element, attrs, tabsCtrl) {
                tabsCtrl.addPane(scope);                
            },
            //template:'<div class="tab-pane" ng-class="{active: $parent.tabInfo.selected}" ng-transclude><table class="table table-bordered table-striped table-hover"><thead><tr><th class="span3">Timestamp</th><th class="span9">Message</th></tr></thead><tbody><tr ng-repeat="log in logs[$parent.tabInfo.title] | orderBy:predicate:!reverse | filter:filterLog"><td><p>{{ log.timestamp | date:"d  MMMM,  y - hh:mm a Z" }}</p></td><td><p>{{ log.message }}</p></td></tr></tbody></table></div>',
            template:'<div class="tab-pane" ng-class="{active: $parent.tabInfo.selected}" ng-transclude></div>',
            replace: true
        };
    });