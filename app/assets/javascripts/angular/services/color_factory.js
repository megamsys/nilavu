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