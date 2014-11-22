app.factory("ColorFactory", function() {

  var colorPalette = [
    //'#DEFFA1',
    // '#D26771',
   // '#6CCC70',
   // '#FF8900',
   // '#A141C5',
   // '#4A556C',
   // '#239928'
   "#3cc051", 
   "#6DABE5", 
   '#FF8900',
   "#52e136"
  ];

  var currentColorIndex = 0;

  var getFn = function() {
    if (currentColorIndex >= colorPalette.length-1) {
      currentColorIndex = 0;
    }
    var color = colorPalette[currentColorIndex];
    currentColorIndex++;
    return color;
  };

  return {
    get: getFn
  };
});