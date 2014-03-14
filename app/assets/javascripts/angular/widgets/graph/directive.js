app.directive("graph", ["FlotrGraphHelper", "GraphModel", "$routeParams", "Sources", function(FlotrGraphHelper, GraphModel, $routeParams, Sources) {

  var currentColors = []; 
  
  var linkFn = function(scope, element, attrs) {  	 
	  
	  function onSuccess(data) {	
		  console.log("TEST!-----------> 1111");
		  console.log(data);
 	  //scope.host=parseHost(data[0]);
		  scope.host=data.host;
		     //scope.uptime_data=parseUptime(data);
		  scope.uptime=data.uptime;
		  scope.os=data.os;
		  scope.cpus=data.cpus;
		  //scope.memory=data.memory;
		  //scope.total_queues=data.total_queues;
		     //scope.rpm_data=parseRPM(data);
		     //scope.new_books=parseNewBooks(data);
		     //scope.total_books=parseTotalBooks(data);
		     //scope.total_queues=parseTotalQueues(data);
		     //scope.target_names=["cpu_user", "cpu_system"];
		     //scope.graph_targets=parseCpuDatapoints(data);
		     console.log("TEST@@@@@@ --------------> @@@@@@@2222");
	         //angular.forEach(scope.target_names,function(name){
	         //       alert(gett(name));
	         //  })
		     //cpu_system_data = [{"datapoints" : scope.graph_targets[0].cpu_system }];
		     cpu_system_data = data.cpu;
		     console.log("TEST CPU DATA==============================>");
		     console.log(data.cpu);
		     //console.log(cpu_system_data);
	    	 var plot1 = $.plot("#cpu_system_graph", FlotrGraphHelper.transformSeriesOfDatapoints(cpu_system_data, scope.widget, currentColors), FlotrGraphHelper.defaultOptions(scope.widget, "cpu_system"));
	    	plot1.setData(FlotrGraphHelper.transformSeriesOfDatapoints(cpu_system_data, scope.widget, currentColors));   		   	
	        plot1.draw();	
	        
	        console.log("TEST DISK DATA==============================>");
		     console.log(data.disk);
		     
	        disk_data = data.disk;
	    	 var plot3 = $.plot("#disk_free_graph", FlotrGraphHelper.transformSeriesOfDatapoints(disk_data, scope.widget, currentColors), FlotrGraphHelper.defaultOptions(scope.widget, "disk_free"));
	    	plot3.setData(FlotrGraphHelper.transformSeriesOfDatapoints(disk_data, scope.widget, currentColors));   		   	
	        plot3.draw();
	        
	        
	        mem_free_data = data.memory;
	    	 var plot5 = $.plot("#mem_free_graph", FlotrGraphHelper.transformSeriesOfDatapoints(mem_free_data, scope.widget, currentColors), FlotrGraphHelper.defaultOptions(scope.widget, "mem_free"));
	    	plot5.setData(FlotrGraphHelper.transformSeriesOfDatapoints(mem_free_data, scope.widget, currentColors));   		   	
	        plot5.draw();
	        
	        nginx_requests_data = data.network;
	        var plot2 = $.plot("#nginx_requests_graph", FlotrGraphHelper.transformSeriesOfDatapoints(nginx_requests_data, scope.widget, currentColors), FlotrGraphHelper.defaultOptions(scope.widget, "nginx_requests"));
	    	plot2.setData(FlotrGraphHelper.transformSeriesOfDatapoints(nginx_requests_data, scope.widget, currentColors));   		   	
	        plot2.draw();
	        
	        
	        /*
	              
	       
	        
	        proc_run_data = [{"datapoints" : scope.graph_targets[0].proc_run }];
	    	 var plot4 = $.plot("#proc_run_graph", FlotrGraphHelper.transformSeriesOfDatapoints(proc_run_data, scope.widget, currentColors), FlotrGraphHelper.defaultOptions(scope.widget, "proc_run"));
	    	plot4.setData(FlotrGraphHelper.transformSeriesOfDatapoints(proc_run_data, scope.widget, currentColors));   		   	
	        plot4.draw();
	        
	        mem_free_data = [{"datapoints" : scope.graph_targets[0].mem_free }];
	    	 var plot5 = $.plot("#mem_free_graph", FlotrGraphHelper.transformSeriesOfDatapoints(mem_free_data, scope.widget, currentColors), FlotrGraphHelper.defaultOptions(scope.widget, "mem_free"));
	    	plot5.setData(FlotrGraphHelper.transformSeriesOfDatapoints(mem_free_data, scope.widget, currentColors));   		   	
	        plot5.draw();
	        
	        bytes_out_data = [{"datapoints" : scope.graph_targets[0].bytes_out }];
	    	 var plot6 = $.plot("#bytes_out_graph", FlotrGraphHelper.transformSeriesOfDatapoints(bytes_out_data, scope.widget, currentColors), FlotrGraphHelper.defaultOptions(scope.widget, "bytes_out"));
	    	plot6.setData(FlotrGraphHelper.transformSeriesOfDatapoints(bytes_out_data, scope.widget, currentColors));   		   	
	        plot6.draw();
	        */
	      //element.height(265);
	      //console.log("element"+element);
	      //Flotr.draw(element[0], FlotrGraphHelper.transformSeriesOfDatapoints(data, scope.widget, currentColors), FlotrGraphHelper.defaultOptions(scope.widget, 0.7));
	        var cyaxisLabel = $("<div class='axisLabel cyaxisLabel'></div>")
			.text("%")
			.appendTo("#cpu_system_graph");
	        var cxaxisLabel = $("<div class='axisLabel cxaxisLabel'></div>")
			.text("cpu_system")
			.appendTo("#cpu_system_graph");
	        
	        var dfyaxisLabel = $("<div class='axisLabel dfyaxisLabel'></div>")
			.text("GB")
			.appendTo("#disk_free_graph");
	        var dfxaxisLabel = $("<div class='axisLabel dfxaxisLabel'></div>")
			.text("disk_free")
			.appendTo("#disk_free_graph");
	        
	        
	        var mfyaxisLabel = $("<div class='axisLabel mfyaxisLabel'></div>")
			.text("GB")
			.appendTo("#mem_free_graph");
	        var mfxaxisLabel = $("<div class='axisLabel mfxaxisLabel'></div>")
			.text("mem_free")
			.appendTo("#mem_free_graph");
	        
	        var nyaxisLabel = $("<div class='axisLabel nyaxisLabel'></div>")
			.text("Bytes")
			.appendTo("#nginx_requests_graph");
	        var nxaxisLabel = $("<div class='axisLabel nxaxisLabel'></div>")
			.text("nginx_requests")
			.appendTo("#nginx_requests_graph");
	        
	        
	        /*
	        
	        	        
	        var pryaxisLabel = $("<div class='axisLabel pryaxisLabel'></div>")
			.text("%")
			.appendTo("#proc_run_graph");
	        var prxaxisLabel = $("<div class='axisLabel prxaxisLabel'></div>")
			.text("proc_run")
			.appendTo("#proc_run_graph");
	        
	        var mfyaxisLabel = $("<div class='axisLabel mfyaxisLabel'></div>")
			.text("%")
			.appendTo("#mem_free_graph");
	        var mfxaxisLabel = $("<div class='axisLabel mfxaxisLabel'></div>")
			.text("mem_free")
			.appendTo("#mem_free_graph");
	        
	        var boyaxisLabel = $("<div class='axisLabel boyaxisLabel'></div>")
			.text("%")
			.appendTo("#bytes_out_graph");
	        var boxaxisLabel = $("<div class='axisLabel boxaxisLabel'></div>")
			.text("bytes_out")
			.appendTo("#bytes_out_graph");
			*/
		// Since CSS transforms use the top-left corner of the label as the transform origin,
		// we need to center the y-axis label by shifting it down by half its width.
		// Subtract 20 to factor the chart's bottom margin into the centering.

		cyaxisLabel.css("margin-top", cyaxisLabel.width() / 2 + 115);  
		cyaxisLabel.css("margin-left", cyaxisLabel.width() / 2 + 8); 
		cxaxisLabel.css("margin-top", cyaxisLabel.width() / 2 + 270); 
		cxaxisLabel.css("margin-left", cyaxisLabel.width() / 2 + 240); 
		
		
		dfyaxisLabel.css("margin-top", dfyaxisLabel.width() / 2 + 115);  
		dfyaxisLabel.css("margin-left", dfyaxisLabel.width() / 2 + 8); 
		dfxaxisLabel.css("margin-top", dfyaxisLabel.width() / 2 + 270); 
		dfxaxisLabel.css("margin-left", dfyaxisLabel.width() / 2 + 240); 
		
		
		mfyaxisLabel.css("margin-top", mfyaxisLabel.width() / 2 + 115); 
		mfyaxisLabel.css("margin-left", mfyaxisLabel.width() / 2 + 8);
		mfxaxisLabel.css("margin-top", mfyaxisLabel.width() / 2 + 270); 
		mfxaxisLabel.css("margin-left", mfyaxisLabel.width() / 2 + 240);
		
		
		nyaxisLabel.css("margin-top", nyaxisLabel.width() / 2 + 115); 
		nyaxisLabel.css("margin-left", nyaxisLabel.width() / 2 + 8);
		nxaxisLabel.css("margin-top", nyaxisLabel.width() / 2 + 270); 
		nxaxisLabel.css("margin-left", nyaxisLabel.width() / 2 + 240);
		
		/*
		
		
		pryaxisLabel.css("margin-top", pryaxisLabel.width() / 2 + 115); 
		pryaxisLabel.css("margin-left", pryaxisLabel.width() / 2 + 8);
		prxaxisLabel.css("margin-top", pryaxisLabel.width() / 2 + 270); 
		prxaxisLabel.css("margin-left", pryaxisLabel.width() / 2 + 240);
		
		mfyaxisLabel.css("margin-top", mfyaxisLabel.width() / 2 + 115); 
		mfyaxisLabel.css("margin-left", mfyaxisLabel.width() / 2 + 8);
		mfxaxisLabel.css("margin-top", mfyaxisLabel.width() / 2 + 270); 
		mfxaxisLabel.css("margin-left", mfyaxisLabel.width() / 2 + 240);
		
		boyaxisLabel.css("margin-top", boyaxisLabel.width() / 2 + 115); 
		boyaxisLabel.css("margin-left", boyaxisLabel.width() / 2 + 8);
		boxaxisLabel.css("margin-top", boyaxisLabel.width() / 2 + 270); 
		boxaxisLabel.css("margin-left", boyaxisLabel.width() / 2 + 240);
		*/
	  }     

	  function gett(name){
		  return "scope.graph_targets[0].cpu_system";
	  }
	  
    function update() {  
    	//if ($routeParams.book != null) {    		
    		//return GraphModel.getData(scope.widget, $routeParams.book).success(onSuccess);
    	//}
    	//else {        
    	scope.widgets.targets = "cpu_system";
		  console.log("TEST!-----------> 44444444444");

    		return GraphModel.getData(scope.widget).success(onSuccess);
    	//}
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
	  templateUrl: 'angular/templates/widgets/pernode/show.html.erb',
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
