import {
    popupAjaxError
} from 'nilavu/lib/ajax-error';
import { on, observes } from 'ember-addons/ember-computed-decorators';
export default Ember.Component.extend({

    didInsertElement: function() {
      //this.startRefreshing();
    },

    @observes('selectedTab')
    tabChanged() {    
      if (Ember.isEqual(this.get('selectedTab'), "cpu")) {
        this.startRefreshing();
      };
    },

    willDestroyElement: function() {
      this.set('refreshing', false);
    },

    startRefreshing: function() {
        this.set('refreshing', true);
        Em.run.later(this, this.refresh, 300);
    },

    refresh: function() {
        if (!Ember.isEqual(this.get('selectedTab'), "cpu"))
            return;
        this.getMetrics();
        Em.run.later(this, this.refresh, 300);
    },

    getMetrics: function() {
        var _this = this;
        Nilavu.ajax("/metrics/containers/?ip="+this.get("ip"), {
            type: 'GET'
        }).then(function(result) {
            _this._drawChart(result);
            return;
        });
        return;
    },

    _drawChart: function(data) {
        var stats = data;
        if (!this._hasResource(stats, "cpu")) {
            return;
        }

        var titles = [
            "Time", "Total"
        ];
        var data = [];
        for (var i = 1; i < stats.stats.length; i++) {

            var cur = stats.stats[i];
            var prev = stats.stats[i - 1];
            var intervalInNs = this._getInterval(cur.timestamp, prev.timestamp);

            var elements = [];
            elements.push(cur.timestamp);
            elements.push((cur.cpu.usage.total - prev.cpu.usage.total) / intervalInNs);
            data.push(elements);
        }

        var min = Infinity;
        var max = -Infinity;

        for (var i = 0; i < data.length; i++) {
            if (data[i] != null) {
                data[i][0] = new Date(data[i][0]);
            }

            for (var j = 1; j < data[i].length; j++) {
                var val = data[i][j];
                if (val < min) {
                    min = val;
                }
                if (val > max) {
                    max = val;
                }
            }
        }

        var minWindow = min - (max - min) / 15;
        if (minWindow < 0) {
            minWindow = 0;
        }
        var dataTable = new google.visualization.DataTable();

        dataTable.addColumn('datetime', titles[0]);
        for (var i = 1; i < titles.length; i++) {
            dataTable.addColumn('number', titles[i]);
        }
        dataTable.addRows(data);

        var opts = {
            curveType: 'function',
            height: 300,
            width: 800,
            chartArea: {
                left: 110,
                top: 5
            },
            legend: {
                position: "none"
            },
            focusTarget: "category",
            vAxis: {
                title: "Cores",
                viewWindow: {
                    min: minWindow
                }
            },
            legend: {
                position: 'bottom'
            }
        };
        if (min == max) {
            opts.vAxis.viewWindow.max = 3.1 * max;
            opts.vAxis.viewWindow.min = 0.9 * max;
        }
        var chart = new google.visualization.LineChart(document.getElementById('chart-cpu'));

        chart.draw(dataTable, opts);

    },

    _hasResource: function(stats, resource) {
        return stats.stats.length > 0 && stats.stats[0][resource];
    },

    _getInterval: function(current, previous) {
        var cur = new Date(current);
        var prev = new Date(previous);

        return (cur.getTime() - prev.getTime()) * 1000000;
    },

});
