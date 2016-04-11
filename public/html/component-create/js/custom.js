$( document ).ready(function() {
	console.log("Component Ready");
	
	$("#ex13").slider({
		ticks: [512, 1024, 2048, 4096, 8192, 16384, 32768, 65536],
		ticks_positions: [0, 14.28, 28.57, 42.85, 57.13, 71.41, 85.69, 100],
		ticks_labels: ['512MB', '1GB', '2GB', '4GB', '8GB', '16GB', '32GB', '64GB'],
		ticks_snap_bounds: 250
	});
	$("#ex14").slider({
		ticks: [10, 20, 40, 80, 160, 320, 640, 1280],
		ticks_positions: [0, 14.28, 28.57, 42.85, 57.13, 71.41, 85.69, 100],
		ticks_labels: ['10GB', '20GB', '40GB', '80GB', '160GB', '320GB', '640GB', '1.28TB'],
		ticks_snap_bounds: 10
	});

	var isOpen1 = false;
	
	$(document).on("click", "#slideDown", function (ev) {
		console.log("slideDown click registered");
		if (isOpen1 == false) {
			$(".hideme").slideToggle(250);
			isOpen1 = true;
		}
	})
	var isOpen2 = false;
	
	$(document).on("click", "#slideDown2", function (ev) {
		if (isOpen2 == false) {
			$(".hideme2").slideToggle(250);
			isOpen2 = true;
		}
	})
	var isOpen3 = false;
	
	$(document).on("click", "#slideDown3", function (ev) {
		if (isOpen3 == false) {
			$(".hideme3").slideToggle(250);
			isOpen3 = true;
		}
		if (isOpenCustom == true) { //Close Custom (Advanced Settings)
			$(".hideme-custom").slideToggle(250);
			isOpenCustom = false;
		}
	})
	var isOpenCustom = false;
	
	$(document).on("click", "#slideDown-Custom", function (ev) {
		if (isOpen3 == false) {
			$(".hideme3").slideToggle(250);
			isOpen3 = true;
		}
		if (isOpenCustom == false) { //Open Custom settings
			$(".hideme-custom").slideToggle(250);
			isOpenCustom = true;
			$(".aContent").slideToggle(250);
		}
	})
	$(".aHead").click(function () {
		$header = $(this);
		//getting the next element
		$content = $header.next();
		//open up the content needed - toggle the slide- if visible, slide up, if not slidedown.
		$content.slideToggle(250);
		
	});
});