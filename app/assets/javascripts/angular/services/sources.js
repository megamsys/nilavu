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
app.factory("Sources", function() {

    // TODO: kind mismatch graph/datapoints
  function kindMapping(kind) {
    if (kind === "graph") kind = "datapoints";
    if (kind === "meter") kind = "number";
    return kind;
  }

  function sourceConfig(widget) {
    return $.Sources[kindMapping(widget.kind)][widget.source];	
  }

  function sourceMapping(source) {
    return {
      value: source.name,
      //label: source.name,
      //disabled: !source.available,
      //supports_functions: source.supports_functions,
      //supports_target_browsing: source.supports_target_browsing
    };
  }

  // TODO: handle disabled sources
  // disabled attribute not available in current Angular select ng-options directive
  function availableSources(kind) {	
    var sources = $.Sources[kind];
    return _.compact(_.map(sources, function(source) {
      //if (source.available) return sourceMapping(source);
    	return sourceMapping(source);
    }));
  }

  function supportsTargetBrowsing(widget) {
    var config = sourceConfig(widget);
    return config ? config.supports_target_browsing : false;
  }

  return {
    kindMapping: kindMapping,
    availableSources: availableSources,
    supportsTargetBrowsing: supportsTargetBrowsing
  };
});
