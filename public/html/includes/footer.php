<div class="container">
    <div class="row">
        <div class="col-sm-12 footer-menu">
            <ul class="list-inline text-center">
                <li><a href="http://docs.det.io" target="_blank">Documentation</a></li>
                <li><a href="http://support.det.io" target="_blank">Support</a></li>
            </ul>
        </div>
        <div class="col-sm-12">
            <p class="text-center">© 2016 DET.io / Jonathan Philipos.</p>
        </div>
    </div>
</div>
<!-- BEGIN JAVASCRIPTS(Load javascripts at bottom, this will reduce page load time) -->
<!-- BEGIN CORE PLUGINS -->    
<script src="assets/plugins/jquery-1.11.2.min.js" type="text/javascript"></script>
<script src="assets/plugins/jquery-ui.min.js" type="text/javascript"></script>
<script src="assets/scripts/jquery.radios-to-slider.js"></script>
<script src="assets/scripts/bootstrap-tour-standalone.js"></script>
<script src="assets/plugins/jquery-migrate-1.2.1.min.js" type="text/javascript"></script>
<script src="assets/plugins/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>


<script src="assets/plugins/uniform/jquery.uniform.min.js" type="text/javascript" ></script>
<script src="assets/plugins/jq-validation/validation.jquery.js" type="text/javascript" ></script>
<script src="assets/plugins/jquery-validation-bootstrap-tooltip-master/jquery-validate.bootstrap-tooltip.js" type="text/javascript" ></script>
<!-- END CORE PLUGINS -->	
<script src="assets/plugins/jcarousellite/jquery.jcarousellite.js" type="text/javascript" ></script>
<script src="assets/scripts/jquery.flot.js"></script>   
<script src="assets/scripts/jquery.flot.resize.js"></script>   
<script language="javascript" type="text/javascript" src="assets/scripts/jquery.flot.selection.js"></script>
<script src="assets/plugins/faq/js/jquery.mobile.custom.min.js"></script>
<script src="assets/plugins/faq/js/main.js"></script> <!-- Resource jQuery -->
<script src="assets/plugins/faq/js/modernizr.js"></script> <!-- Modernizr -->
<script src="assets/plugins/snap.svg-min.js"></script> <!-- Snap-SVG -->

<script src="assets/scripts/classie.js"></script> <!-- Navbar -->
<script src="assets/scripts/hovers.js"></script> <!-- Hovers -->

<script src="assets/scripts/gnmenu.js"></script> <!-- Navbar -->
<script src="assets/scripts/jquery.flagstrap.js"></script> <!-- Country Picker -->
<script>
    new gnMenu( document.getElementById( 'gn-menu' ) );
    $('.flagstrap').flagStrap();
    $("#radios").radiosToSlider();
	$("#radios01").radiosToSlider();
	$("#radios02").radiosToSlider();
</script>
 <script>
  // Instance the tour
var tour = new Tour({
  steps: [
  {
    element: ".one",
    title: "<i class='fa fa-soundcloud'></i> Step 1",
    content: "Click to see all our apps and services !!"
  },
      {
    element: ".two",
    title: "<i class='fa fa-soundcloud'></i> Step 2",
    content: "Click to see all our apps and services !!"
  }  
],
  backdrop: true,
  storage: false
});

tour.init();

tour.start();
</script>
<script type="text/javascript">
    $(".default .jCarouselLite").jCarouselLite({
        btnNext: ".default .next",
        btnPrev: ".default .prev",
        start: 2,
        scroll: 3
    });

// LOAD cloud-1 by default
$( "#tab_1_1_2" ).load( "cloud-1.php" );
			(function() {
	
				function init() {
					var speed = 330,
						easing = mina.backout;

					[].slice.call ( document.querySelectorAll( '#grid > a' ) ).forEach( function( el ) {
						var s = Snap( el.querySelector( 'svg' ) ), path = s.select( 'path' ),
							pathConfig = {
								from : path.attr( 'd' ),
								to : el.getAttribute( 'data-path-hover' )
							};

						el.addEventListener( 'mouseenter', function() {
							path.animate( { 'path' : pathConfig.to }, speed, easing );
						} );

						el.addEventListener( 'mouseleave', function() {
							path.animate( { 'path' : pathConfig.from }, speed, easing );
						} );
					} );
				}

				init();

			})();
		</script>
</script>



<script>
$(function () {
  $('[data-toggle="tooltip"]').tooltip()
})
</script>





<script type="text/javascript">

// Secipt to show hide config menu
$(document).ready( function(){

    $('.app_config').click( function(event){

    	$('.config_menu').hide();
		$('.app_config').removeClass('config_acive');
    	cls = this.id;
    	// $('.app_config').removeClass('config_acive');
        event.stopPropagation();
        $('.'+cls).toggle();
        $(this).toggleClass('config_acive');
    });

    $(document).click( function(){
        $('.config_menu').hide();
        $('.app_config').removeClass('config_acive');
    });
});

// Remove alert message on clicking the close button
$(".c_remove").click(function(){
    $('.c_remove_main').hide();
});

// RUNTIME MENU
$(document).ready( function(){

    $('.app_config').click( function(event){

        $('.config_menu').hide();
        $('.app_config').removeClass('config_acive');
        cls = this.id;
        // $('.app_config').removeClass('config_acive');
        event.stopPropagation();
        $('.'+cls).toggle();
        $(this).toggleClass('config_acive');
    });

    $(document).click( function(){
        $('.config_menu').hide();
        $('.app_config').removeClass('config_acive');
    });
});   
</script>
<script type="text/javascript">
$(window).load(function() {
    $(function() {

       function randValue() {
                    return (Math.floor(Math.random() * (1 + 40 - 20))) + 20;
                }
                var pageviews = [
                    [1, randValue()],
                    [2, randValue()],
                    [3, 2 + randValue()],
                    [4, 3 + randValue()],
                    [5, 5 + randValue()],
                    [6, 10 + randValue()],
                    [7, 15 + randValue()],
                    [8, 20 + randValue()],
                    [9, 25 + randValue()],
                    [10, 30 + randValue()],
                    
                ];
                var visitors = [
                    [1, randValue() - 5],
                    [2, randValue() - 5],
                    [3, randValue() - 5],
                    [4, 6 + randValue()],
                    [5, 5 + randValue()],
                    [6, 20 + randValue()],
                    [7, 25 + randValue()],
                    [8, 36 + randValue()],
                    [9, 26 + randValue()],
                    [10, 38 + randValue()],
                    
                ];

                var plot = $.plot($("#chart_2"), [{
                            data: pageviews,
                            label: "Unique Visits"
                        }, {
                            data: visitors,
                            label: "Page Views"
                        }
                    ], {
                        series: {
                            lines: {
                                show: true,
                                lineWidth: 2,
                                fill: true,
                                fillColor: {
                                    colors: [{
                                            opacity: 0.05
                                        }, {
                                            opacity: 0.01
                                        }
                                    ]
                                }
                            },
                            points: {
                                show: true
                            },
                            shadowSize: 1
                        },
                        grid: {
                            hoverable: true,
                            clickable: true,
                            tickColor: "#eee",
                            borderWidth: {top: 0, right: 0, bottom: 1, left: 1},
                            borderColor: {bottom: "#e5e6ef", left: "#e5e6ef"}
                        },
                        colors: ["#3cc051", "#6DABE5", "#52e136"],
                        xaxis: {
                            ticks: 5,
                            tickDecimals: 0,
                            tickLength:0
                        },
                        yaxis: {
                            ticks: 5,
                            tickDecimals: 0,
                            tickLength:0
                        }
                    });


                function showTooltip(x, y, contents) {
                    $('<div id="tooltip">' + contents + '</div>').css({
                            position: 'absolute',
                            display: 'none',
                            top: y + 5,
                            left: x + 15,
                            border: '1px solid #333',
                            padding: '4px',
                            color: '#fff',
                            'border-radius': '3px',
                            'background-color': '#333',
                            opacity: 0.80
                        }).appendTo("body").fadeIn(200);
                }

                var previousPoint = null;
                $("#chart_2").bind("plothover", function (event, pos, item) {
                    $("#x").text(pos.x.toFixed(2));
                    $("#y").text(pos.y.toFixed(2));

                    if (item) {
                        if (previousPoint != item.dataIndex) {
                            previousPoint = item.dataIndex;

                            $("#tooltip").remove();
                            var x = item.datapoint[0].toFixed(2),
                                y = item.datapoint[1].toFixed(2);

                            showTooltip(item.pageX, item.pageY, item.series.label + " of " + x + " = " + y);
                        }
                    } else {
                        $("#tooltip").remove();
                        previousPoint = null;
                    }
                });

    });
});   

</script>

<script type="text/javascript">
$(window).load(function() {
    $(function() {

       function randValue() {
                    return (Math.floor(Math.random() * (1 + 40 - 20))) + 20;
                }
                var pageviews = [
                    [1, randValue()],
                    [2, randValue()],
                    [3, 2 + randValue()],
                    [4, 3 + randValue()],
                    [5, 5 + randValue()],
                    [6, 10 + randValue()],
                    [7, 15 + randValue()],
                    [8, 20 + randValue()],
                    [9, 25 + randValue()],
                    [10, 30 + randValue()],
                    [11, 35 + randValue()],
                    [12, 25 + randValue()],
                    [13, 15 + randValue()],
                    [14, 20 + randValue()],
                    [15, 45 + randValue()],
                    [16, 50 + randValue()],
                    [17, 65 + randValue()],
                    [18, 70 + randValue()],
                    [19, 85 + randValue()],
                    [20, 80 + randValue()],
                    [21, 75 + randValue()],
                    [22, 80 + randValue()],
                    [23, 75 + randValue()],
                    [24, 70 + randValue()],
                    [25, 65 + randValue()],
                    [26, 75 + randValue()],
                    [27, 80 + randValue()],
                    [28, 85 + randValue()],
                    [29, 90 + randValue()],
                    [30, 95 + randValue()]
                ];
                var visitors = [
                    [1, randValue() - 5],
                    [2, randValue() - 5],
                    [3, randValue() - 5],
                    [4, 6 + randValue()],
                    [5, 5 + randValue()],
                    [6, 20 + randValue()],
                    [7, 25 + randValue()],
                    [8, 36 + randValue()],
                    [9, 26 + randValue()],
                    [10, 38 + randValue()],
                    [11, 39 + randValue()],
                    [12, 50 + randValue()],
                    [13, 51 + randValue()],
                    [14, 12 + randValue()],
                    [15, 13 + randValue()],
                    [16, 14 + randValue()],
                    [17, 15 + randValue()],
                    [18, 15 + randValue()],
                    [19, 16 + randValue()],
                    [20, 17 + randValue()],
                    [21, 18 + randValue()],
                    [22, 19 + randValue()],
                    [23, 20 + randValue()],
                    [24, 21 + randValue()],
                    [25, 14 + randValue()],
                    [26, 24 + randValue()],
                    [27, 25 + randValue()],
                    [28, 26 + randValue()],
                    [29, 27 + randValue()],
                    [30, 31 + randValue()]
                ];

                var plot = $.plot($("#chart_3"), [{
                            data: pageviews,
                            label: "Unique Visits"
                        }, {
                            data: visitors,
                            label: "Page Views"
                        }
                    ], {
                        series: {
                            lines: {
                                show: true,
                                lineWidth: 2,
                                fill: true,
                                fillColor: {
                                    colors: [{
                                            opacity: 0.05
                                        }, {
                                            opacity: 0.01
                                        }
                                    ]
                                }
                            },
                            points: {
                                show: true
                            },
                            shadowSize: 2
                        },
                        grid: {
                            hoverable: true,
                            clickable: true,
                            tickColor: "#eee",
                            borderWidth: {top: 0, right: 0, bottom: 1, left: 1},
                            borderColor: {bottom: "#e5e6ef", left: "#e5e6ef"}
                        },
                        colors: ["#3cc051", "#6DABE5", "#52e136"],
                        xaxis: {
                            ticks: 11,
                            tickDecimals: 0,
                            tickLength:0
                        },
                        yaxis: {
                            ticks: 11,
                            tickDecimals: 0,
                            tickLength:0
                        }
                    });


                function showTooltip(x, y, contents) {
                    $('<div id="tooltip">' + contents + '</div>').css({
                            position: 'absolute',
                            display: 'none',
                            top: y + 5,
                            left: x + 15,
                            border: '1px solid #333',
                            padding: '4px',
                            color: '#fff',
                            'border-radius': '3px',
                            'background-color': '#333',
                            opacity: 0.80
                        }).appendTo("body").fadeIn(200);
                }

                var previousPoint = null;
                $("#chart_3").bind("plothover", function (event, pos, item) {
                    $("#x").text(pos.x.toFixed(2));
                    $("#y").text(pos.y.toFixed(2));

                    if (item) {
                        if (previousPoint != item.dataIndex) {
                            previousPoint = item.dataIndex;

                            $("#tooltip").remove();
                            var x = item.datapoint[0].toFixed(2),
                                y = item.datapoint[1].toFixed(2);

                            showTooltip(item.pageX, item.pageY, item.series.label + " of " + x + " = " + y);
                        }
                    } else {
                        $("#tooltip").remove();
                        previousPoint = null;
                    }
                });

    });
});   

</script>
<style type="text/css">
.demo-container {
    box-sizing: border-box;
    /*width: 850px;*/
    height: 300px;
    padding: 20px 15px 15px 15px;
    margin: 15px auto 30px auto;
    /*border: 1px solid #ddd;*/
    background: #fff;
    /*background: linear-gradient(#f6f6f6 0, #fff 50px);
    background: -o-linear-gradient(#f6f6f6 0, #fff 50px);
    background: -ms-linear-gradient(#f6f6f6 0, #fff 50px);
    background: -moz-linear-gradient(#f6f6f6 0, #fff 50px);
    background: -webkit-linear-gradient(#f6f6f6 0, #fff 50px);*/
   /* box-shadow: 0 3px 10px rgba(0,0,0,0.15);
    -o-box-shadow: 0 3px 10px rgba(0,0,0,0.1);
    -ms-box-shadow: 0 3px 10px rgba(0,0,0,0.1);
    -moz-box-shadow: 0 3px 10px rgba(0,0,0,0.1);
    -webkit-box-shadow: 0 3px 10px rgba(0,0,0,0.1);*/
}

.demo-placeholder {
    width: 100%;
    height: 100%;
    font-size: 14px;
    line-height: 1.2em;
}

.legend table {
    border-spacing: 5px;
}
</style>
<script type="text/javascript">
$('.inner-menu').click(function(e) {
    e.preventDefault();
    $('.inner-child').toggle();
});
</script>
</body>
<!-- END BODY -->
</html>