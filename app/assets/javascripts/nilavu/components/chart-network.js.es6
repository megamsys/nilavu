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
            this.startRefreshing();
        }
    },

    @observes('selectedTab')
    tabChanged() {
        if (Ember.isEqual(this.get('selectedTab'), "network")) {
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

    willDestroyElement: function() {
        this.set('refreshing', false);
    },

    startRefreshing: function() {
        this.set('refreshing', true);
        Em.run.later(this, this.refresh, 300);
    },

    refresh: function() {
        if (!Ember.isEqual(this.get('selectedTab'), "network"))
            return;
        this.getMetrics();
        Em.run.later(this, this.refresh, 300);
    },

    getMetrics: function() {
        var _this = this;
        Nilavu.ajax("/metrics/containers/?ip=" + this.get("runningIP"), {
            type: 'GET'
        }).then(function(result) {
            _this.set("showNetworkSpinnerVisible", false);
            _this._drawChart(result);
            return;
        });
        return;
    },

    _drawChart: function(data) {
        var stats = data;
        var self = this;

        if (stats.spec.has_network && !this._hasResource(stats, "network")) {
            return;
        }
        var interfaceIndex = -1;
        if (stats.stats.length > 0) {
            interfaceIndex = this._getNetworkInterfaceIndex("eth0", stats.stats[0].network.interfaces);
            //interfaceIndex = this._getNetworkInterfaceIndex("eth1", stats.stats[0].network.interfaces);
        }
        if (interfaceIndex < 0) {
            //  console.log("Unable to find interface\"", interfaceName, "\" in ", stats.stats.network);
            self.notificationMessages.error(I18n.t("vm_management.network.interface_error"));
            return;
        }
        var titles = [
            "Time", "Tx bytes", "Rx bytes"
        ];
        var data = [];
        for (var i = 1; i < stats.stats.length; i++) {
            var cur = stats.stats[i];
            var prev = stats.stats[i - 1];
            var intervalInSec = this._getInterval(cur.timestamp, prev.timestamp) / 1000000000;
            var elements = [];
            elements.push(cur.timestamp);
            elements.push((cur.network.interfaces[interfaceIndex].tx_bytes - prev.network.interfaces[interfaceIndex].tx_bytes) / intervalInSec);
            elements.push((cur.network.interfaces[interfaceIndex].rx_bytes - prev.network.interfaces[interfaceIndex].rx_bytes) / intervalInSec);
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
                title: "Bytes per Second",
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

        var chart = new google.visualization.LineChart(document.getElementById("chart-network"));
        chart.draw(dataTable, opts);

    },

    _hasResource: function(stats, resource) {
        return stats.stats.length > 0 && stats.stats[0][resource];
    },

    _getNetworkInterfaceIndex: function(interfaceName, interfaces) {
        for (var i = 0; i < interfaces.length; i++) {
            if (interfaces[i].name == interfaceName) {
                return i;
            }
        }
        return -1;
    },

    _getInterval: function(current, previous) {
        var cur = new Date(current);
        var prev = new Date(previous);

        return (cur.getTime() - prev.getTime()) * 1000000;
    },

});
