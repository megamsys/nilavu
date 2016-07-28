import {
    popupAjaxError
} from 'nilavu/lib/ajax-error';
import {
    on,
    observes
} from 'ember-addons/ember-computed-decorators';
export default Ember.Component.extend({

    runningIP: null,

    setIPS() {
        this.set('privateipv4', this._filterOutputs("privateipv4"));
        this.set('publicipv4', this._filterOutputs("publicipv4"));
        this.set('privateipv6', this._filterOutputs("privateipv6"));
        this.set('publicipv6', this._filterOutputs("publicipv6"));
    },

    _filterOutputs(key) {
        if (Em.isEmpty(this.get('model.outputs'))) return "";
        if (!this.get('model.outputs').filterBy('key', key)[0]) return "";
        return this.get('model.outputs').filterBy('key', key)[0].value;
    },

    @observes('runningIP')
    validateIP() {
        if (!Em.isBlank(this.get('runningIP'))) {
            this.set("showNetworkSpinnerVisible", false);
            this.getMachineInfo();
            this.startRefreshing();
        }
    },

    willDestroyElement: function() {
        this.set('refreshing', false);
    },

    startRefreshing: function() {
        this.set('refreshing', true);
        Em.run.later(this, this.refresh, 300);
    },

    @observes('selectedTab')
    tabChanged() {
        if (Ember.isEqual(this.get('selectedTab'), "ram")) {
            this.setIPS();
            this.set("showNetworkSpinnerVisible", true);
            this.validatePrivateIPv4();
        };
    },

    validatePrivateIPv4: function() {
        var self = this;
        if (!Em.isBlank(self.get('runningIP'))) {
          this.startRefreshing();
          return;
        }
        if (Em.isBlank(self.get('privateipv4'))) {
            self.validatePublicIPv4();
            return;
        }
        Nilavu.ajax("/metrics/containers/?ip=" + self.get('privateipv4'), {
            type: 'GET'
        }).then(function(result) {
            self.set("runningIP", self.get('privateipv4'));
            return;
        }).catch(function(e) {
            self.validatePublicIPv4();
        });
    },

    validatePublicIPv4: function() {
        var self = this;
        if (!Em.isBlank(self.get('runningIP'))) {
          this.startRefreshing();
          return;
        }
        if (Em.isBlank(self.get('publicipv4'))) {
            self.validatePrivateIPv6();
            return;
        }
        Nilavu.ajax("/metrics/containers/?ip=" + self.get('publicipv4'), {
            type: 'GET'
        }).then(function(result) {
            self.set("runningIP", self.get('publicipv4'));
            return;
        }).catch(function(e) {
            self.validatePrivateIPv6();
        });
    },

    validatePrivateIPv6: function() {
        var self = this;
        if (!Em.isBlank(self.get('runningIP'))) {
          this.startRefreshing();
          return;
        }
        if (Em.isBlank(self.get('privateipv6'))) {
            self.validatePublicIPv6();
            return;
        }
        Nilavu.ajax("/metrics/containers/?ip=" + self.get('privateipv6'), {
            type: 'GET'
        }).then(function(result) {
            self.set("runningIP", self.get('privateipv6'));
            return;
        }).catch(function(e) {
            self.validatePublicIPv6();
        });
    },

    validatePublicIPv6: function() {
        var self = this;
        if (!Em.isBlank(self.get('runningIP'))) {
          this.startRefreshing();
          return;
        }
        if (Em.isBlank(self.get('publicipv6'))) {
            this.set("showNetworkSpinnerVisible", false);
            self.notificationMessages.error(I18n.t("vm_management.network.empty_ip_error"));
            return;
        }
        Nilavu.ajax("/metrics/containers/?ip=" + self.get('publicipv6'), {
            type: 'GET'
        }).then(function(result) {
            self.set("runningIP", self.get('publicipv6'));
            return;
        }).catch(function(e) {
            this.set("showNetworkSpinnerVisible", false);
            self.notificationMessages.error(I18n.t("vm_management.network.connect_error"));
        });
    },

    showSpinner: function() {
        return this.get("showNetworkSpinnerVisible");
    }.property("showNetworkSpinnerVisible"),

    refresh: function() {
        if (!Ember.isEqual(this.get('selectedTab'), "ram"))
            return;
        this.getMetrics();
        Em.run.later(this, this.refresh, 300);
    },

    getMetrics: function() {
        var _this = this;
        Nilavu.ajax("/metrics/containers/?ip=" + this.get("runningIP"), {
            type: 'GET'
        }).then(function(stats) {
            _this.set("showNetworkSpinnerVisible", false);
            _this._drawChart(stats);
            return;
        });
        return;
    },

    getMachineInfo() {
        var _this = this;
        Nilavu.ajax("/metrics/machine/?ip=" + this.get("runningIP"), {
            type: 'GET'
        }).then(function(machineInfo) {
            _this.set("showNetworkSpinnerVisible", false);
            _this.set('machineInfo', machineInfo);
            return;
        });
    },

    _drawChart: function(stats) {
        var stats = stats;
        var machineInfo = this.get('machineInfo');

        var titles = [
            "Time", "Total", "Hot"
        ];
        var data = [];
        for (var i = 1; i < stats.stats.length; i++) {
            var cur = stats.stats[i];
            var oneMegabyte = 1024 * 1024;
            var oneGigabyte = 1024 * oneMegabyte;
            var elements = [];
            elements.push(cur.timestamp);
            elements.push(cur.memory.usage / oneMegabyte);
            elements.push(cur.memory.working_set / oneMegabyte);
            data.push(elements);
        }
        var memory_limit = machineInfo.memory_capacity;
        if (stats.spec.memory.limit && (stats.spec.memory.limit < memory_limit)) {
            memory_limit = stats.spec.memory.limit;
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
        var minWindow = min - (max - min) / 10;
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
                title: "Megabytes",
                viewWindow: {
                    min: minWindow
                }
            },
            legend: {
                position: 'bottom'
            }
        };
        if (min == max) {
            opts.vAxis.viewWindow.max = 1.1 * max;
            opts.vAxis.viewWindow.min = 0.9 * max;
        }
        var chart = new google.visualization.LineChart(document.getElementById("chart-ram"));
        chart.draw(dataTable, opts);

    },

});
