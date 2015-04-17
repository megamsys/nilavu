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