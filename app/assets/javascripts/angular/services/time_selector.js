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
app.factory("TimeSelector", function() {

  function getFrom(rangeString) {
    var date = new Date();
    if (isDayBoundary(rangeString)) date.setHours(0,0,0,0);

    return Math.round( (date.getTime() - getRange(rangeString)) / 1000);
  }

  function getPreviousFrom(rangeString) {
    var date = new Date();
    if (isDayBoundary(rangeString)) date.setHours(0,0,0,0);

    return Math.round( (date.getTime() - getRange(rangeString) * 2) / 1000);
  }

  function getCurrent(rangeString) {
    var date = new Date();
    if (isDayBoundary(rangeString)) date.setHours(23, 59, 59, 0);
    if (isPreviousBoundary(rangeString)) {
      var range = getRange(rangeString);
      if (rangeString !== "yesterday") range = range / 2;
      return Math.round( (date.getTime() - range) / 1000);
    } else {
      return Math.round(date.getTime() / 1000);
    }
  }

  function isDayBoundary(rangeString) {
    var ranges = ["today", "yesterday", "this-week", "previous-week", "this-month", "previous-month", "this-year", "previous-year"];
    return _.contains(ranges, rangeString);
  }

  function isPreviousBoundary(rangeString) {
    var ranges = ["yesterday", "previous-week", "previous-month", "previous-year"];
    return _.contains(ranges, rangeString);
  }

  function getRange(rangeString) {
    var range = null;
    switch(rangeString) {
      case "today":
        range = 1;
        break;
      case "yesterday":
        range = getIntRangeFromString("24-hours");
        break;
      case "this-week":
        range = getIntRangeFromString("7-days");
        break;
      case "previous-week":
        range = getIntRangeFromString("7-days") * 2;
        break;
      case "this-month":
        range = getIntRangeFromString("4-weeks");
        break;
      case "previous-month":
        range = getIntRangeFromString("4-weeks") * 2;
        break;
      case "this-year":
        range = getIntRangeFromString("4-weeks") * 12;
        break;
      case "previous-year":
        range = getIntRangeFromString("4-weeks") * 12 * 2;
        break;
      default:
        range = getIntRangeFromString(rangeString);
    }
    return range;
  }

  function getIntRangeFromString(rangeString) {
    var range = null;
    switch(rangeString) {
      case "30-minutes":
        range = 60*30;
        break;
      case "60-minutes":
        range = 60*60;
        break;
      case "hour":
          range = 3600*1;
          break;  
      case "2hr":
        range = 3600*2;
        break;    
      case "4hr":
        range = 3600*4;
        break;
      case "12-hours":
        range = 3600*12;
        break;
      case "day":
      case "today":
        range = 3600*24;
        break;
      case "3-days":
        range = 3600*24*3;
        break;
      case "week":
        range = 3600*24*7;
        break;
      case "4-weeks":
      case "month":
        range = 3600*24*7*4;
        break;
      default:
        throw "Unknown rangeString: " + rangeString;
    }
    return range * 1000;
  }

  return {
    getFrom: getFrom,
    getPreviousFrom: getPreviousFrom,
    getCurrent: getCurrent
  };
});