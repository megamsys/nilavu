	function jpImportDefaults() {
		jsPlumb.importDefaults({
			Endpoint : [ "Dot", {
				radius : 2
			} ],
			HoverPaintStyle : {
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

	function longestWord(string) {
		var str = string.split(" ");
		var longest = 0;
		var word = null;
		for ( var i = 0; i < str.length; i++) {
			var checkedLetters = "";
			for ( var j = 0; j < str[i].length; j++) {
				if (/[a-zA-Z]/.test(str[i][j])) {
					checkedLetters += str[i][j];
				}
			}
			if (longest < checkedLetters.length) {
				longest = checkedLetters.length;
				word = checkedLetters;
			}
		}
		return word.length * str.length;
	}


