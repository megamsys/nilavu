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
app.factory("ContainerModel", ["$http", "TimeSelector", "Sources", function($http, TimeSelector, Sources) {

	function getParams(config, appkey, host) {
	    return {	
	    	widgetid: config.id,
	    	 from: TimeSelector.getFrom(config.range),
	         to: TimeSelector.getCurrent(config.range),
	    	range: config.range,
	      kind: config.kind,
	      name: config.source,	      
	      target: config.targets,
	      appkey: appkey,
	      host: host
	    };
	  }	 

  function getData(config, appkey, host) {		  
	return $http.get("/api/data_sources/containers.json", { params: getParams(config, appkey, host) });
  }
  
  function getMachineInfo(config, host) {
  	return $http.get("/api/data_sources/containers.json", { params: {kind: config.kind, name: "machines", host: host }});
  }
  
  return {
    getData: getData,
    getMachineInfo: getMachineInfo
  };
  
}]);