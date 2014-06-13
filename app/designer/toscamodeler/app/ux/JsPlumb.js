	function jpImportDefaults() {
		jsPlumb.importDefaults({
			Endpoint : [ "Dot", {
				radius : 2
			} ],
			HoverPaintStyle : {
				strokeStyle : "#1e8151",
				lineWidth : 2
			},
			ConnectionOverlays : [ [ "Arrow", {
				location : 1,
				id : "arrow",
				length : 14,
				foldback : 0.8
			} ], [ "Label", {
				label : "",
				id : "label",
				cssClass : "aLabel"
			} ] ]
		});
	}

	function getJpRectangle(id, name, text, object, css) {

		var graphComponent;
		graphComponent = $('<div>').attr('id', id).attr('name', name).addClass(
				'item').text(text);

		if (!object) {
			graphComponent.attr('object', object);
		}
		graphComponent.css(css);
		return graphComponent;
	}

	function getJpRhombus(id, name, text, object, css) {

		console.log(css)
		var graphComponent;
		graphComponent = $('<div>').attr('id', id).attr('name', name).addClass(
				'decision');

		if (!object) {
			graphComponent.attr('object', object);
		}
		graphComponent.css(css);
		return graphComponent;
	}

