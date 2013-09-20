app.directive("graph", ["FlotrGraphHelper", "GraphModel", "$routeParams", "Sources", function(FlotrGraphHelper, GraphModel, $routeParams, Sources) {

  var currentColors = []; 
  
  var linkFn = function(scope, element, attrs) {  	 
	  
	  function onSuccess(data) {
		  
		     scope.uptime_data=parseUptime(data);
		     scope.rpm_data=parseRPM(data);
	    	 var plot = $.plot("#graph_placeholder", FlotrGraphHelper.transformSeriesOfDatapoints(data, scope.widget, currentColors), FlotrGraphHelper.defaultOptions(scope.widget, 0.7));
	    	plot.setData(FlotrGraphHelper.transformSeriesOfDatapoints(data, scope.widget, currentColors));   		   	
	     	plot.draw();		  
	      //element.height(265);
	      console.log(data);
	      //Flotr.draw(element[0], FlotrGraphHelper.transformSeriesOfDatapoints(data, scope.widget, currentColors), FlotrGraphHelper.defaultOptions(scope.widget, 0.7));
	    }     

    function update() {  
    	if ($routeParams.book != null) {
    		return GraphModel.getData(scope.widget, $routeParams.book).success(onSuccess);
    	}
    	else {    		
    		return GraphModel.getData(scope.widget, "demo").success(onSuccess);
    	}
    }

    function parseUptime(responsedata) {
    	return _.map(responsedata, function(model, index) {    		  
    	       return model.uptime_data;    	    
    	});
    }
    
    function parseRPM(responsedata) {
    	return _.map(responsedata, function(model, index) {    		  
    	       return model.rpm;    	    
    	});
    }
    
    function calculateWidth(size_x) {
      var widthMapping = { 1: 290, 2: 630, 3: 965 };
      return widthMapping[size_x];
    }

    scope.init(update);
   
    scope.$watch("config.size_x", function(newValue, oldValue) {
      if (newValue !== oldValue) {
        element.width(calculateWidth(2));
        scope.init(update);
      }

    });

  };

  return {
      //template: '<div id="graph_placeholder"  style=" height:300px; width:800px"></div>',   
	  //template: '<div class="g_container"></div>',	   
	  //template: '<div class="row-fluid"><div class="span4"><ul class="site-stats"><li><i class="icon-user"></i><strong>{{uptime_data}}</strong><small>Total Uptime(days)</small></li><li class="divider"></li></ul><br/><div class="center" style="text-align: center;"><ul class="stat-boxes"><li class="popover-visits"><div class="left peity_bar_bad"><span>3,5,9,7,12,20,10</span>-50%</div><div class="right"><strong>{{rpm_data}}</strong>Requests Served(rpm)</div></li></ul></div></div><div class="span8"><div class="row-fluid"><div class="span12 center" style="text-align: center;"><ul class="quick-actions"><li><a href="#"><i class="icon-graph"></i>LAST 30-minutes</a></li><li><a href="#"><i class="icon-graph"></i>LAST 60-minutes</a></li><li><a href="#"><i class="icon-graph"></i>LAST 1-hour</a></li></ul></div></div><br/><br/><div id="graph_placeholder" style=" height:300px; width:800px"></div></div></div>',
	  template: JST["angular/templates/widgets/pernode/show"],
	  controller : "WidgetPerNodeCtrl",
	  link: linkFn
  };
}]);







/*app.directive("graph",["GraphModel", function(GraphModel) {

  var currentColors = [];
  console.log(" new graph entry");
  
  var data = [],
	totalPoints = 300;

function getRandomData() {

	if (data.length > 0)
		data = data.slice(1);

	// Do a random walk

	while (data.length < totalPoints) {

		var prev = data.length > 0 ? data[data.length - 1] : 50,
			y = prev + Math.random() * 10 - 5;

		if (y < 0) {
			y = 0;
		} else if (y > 100) {
			y = 100;
		}

		data.push(y);
	}

	// Zip the generated y values with the x values

	var res = [];
	for (var i = 0; i < data.length; ++i) {
		res.push([i, data[i]])
	}

	return res;
}

// Set up the control widget

var updateInterval = 3000;
$("#updateInterval").val(updateInterval).change(function () {
	var v = $(this).val();
	if (v && !isNaN(+v)) {
		updateInterval = +v;
		if (updateInterval < 1) {
			updateInterval = 1;
		} else if (updateInterval > 2000) {
			updateInterval = 2000;
		}
		$(this).val("" + updateInterval);
	}
});

var plot = $.plot("#graph_placeholder", [ getSourceData() ], {
	series: {
		shadowSize: 0	// Drawing is faster without shadows
	},
	yaxis: {
		min: 0,
		max: 100
	},
	xaxis: {
		min: 0,
		max: 50
	}
});

function getSourceData() {
	val = GraphModel.getData("demo").success(function (data, status, headers, config) {
	      console.log("===----===="+data);	  
	      return data;
	  }).error(function (data, status, headers, config) {
	      alert("error");
	      return status;
	});
	return val;
}

function update() {

	//plot.setData([getRandomData()]);
	plot.setData([getSourceData()]);
	
	 //plot.setData([GraphModel.getData("demo")].success(onsuccess));
		// Since the axes don't change, we don't need to call plot.setupGrid()
	plot.draw();	
	setTimeout(update, updateInterval);
}

update();
  
  
 // return {
  //  template: '<div class="graph-container"><plot height=300 aspect=3 stroke-width=2 stroke="red"><lines x="[[seq(0,10,200)]]" y="[[normal(x,5,1)]]"/></plot></div>',
    
 // };
}]);*/