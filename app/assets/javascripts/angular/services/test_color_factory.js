app.factory("TestColorFactory", function() {

  var colorPalette = [
    '#DEFFA1',
    // '#D26771',
    '#239928',
    '#FF89FF',
    '#F141C5',
    '#238900',
    '#239928'
  ];

  var testcurrentColorIndex = 0;

  var getFn = function() {
    if (testcurrentColorIndex >= colorPalette.length-1) {
      testcurrentColorIndex = 0;
    }
    var color = colorPalette[testcurrentColorIndex];
    testcurrentColorIndex++;
    return color;
  };

  return {
    get: getFn
  };
});