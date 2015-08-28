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
app.factory("SuffixFormatter", function() {

  // as defined by http://en.wikipedia.org/wiki/Metric_prefix
  var formatFn = function(val, digits) {
    var negative = val < 0 ? true : false;
    val = parseFloat(val);
    val = Math.abs(val);

    var result = null;
    if (val > 1000000000) {
      result = Math.round(val/1000000000) + "G";
    } else if (val >= 1000000) {
      result = Math.round(val/1000000) + "M";
    } else if (val >= 1000) {
      result = Math.round(val/1000) + "k";
    } else if (val < 1.0) {
      result = parseFloat(Math.round(val * 100) / 100).toFixed(2);
    } else {
      val = val % 1 === 0 ? val.toString() : val.toFixed(digits);
      result = val;
    }

    if (negative) {
      result = "-" + result;
    }

    return result;
  };

  return {
    format: formatFn
  };
});