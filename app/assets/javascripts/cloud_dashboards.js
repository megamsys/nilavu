jQuery(document).ready(function() {
	$("body").removeClass("login");
});

function drawAppDistribution(pieDataJSON) {
	var data = [];
	var i = 0;
	var json = $.parseJSON(JSON.stringify(pieDataJSON));
	$(json).each(function(i, val) {
		$.each(val, function(k, v) {
			data[i] = {
				label : k,
				data : Math.floor(v * 100) + 1
			};
			i++;
		});
	});

	var pie = $
			.plot(
					$(".pie"),
					data,
					{
						series : {
							pie : {
								show : true,
								radius : 3 / 4,
								label : {
									show : true,
									radius : 3 / 4,
									formatter : function(label, series) {
										return '<div style="font-size:8pt;text-align:center;padding:2px;color:white;">'
												+ label
												+ '<br/>'
												+ Math.round(series.percent)
												+ '%</div>';
									},
									background : {
										opacity : 0.5,
										color : '#000'
									}
								},
								innerRadius : 0.2
							},
							legend : {
								show : false
							}
						}
					});
}

function drawCloudDistribution(barDataJSON) {
	var data = [];
	var i = 0;
	var json = $.parseJSON(JSON.stringify(barDataJSON));
	$(json).each(function(i, val) {
		$.each(val, function(k, v) {
			data.push([ k, parseInt(v) ]);
			i++;
		});
	});

	$.plot(".bars", [ data ], {
		grid : {
			borderColor : "#eeeeee",
			borderWidth : 1,
			color : "#AAAAAA"
		},
		series : {
			bars : {
				show : true,
				barWidth : 0.6,
				align : "center"
			}
		},
		xaxis : {
			mode : "categories",
			tickLength : 0
		}
	});

}
