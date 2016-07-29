import {
    setting
} from 'nilavu/lib/computed';

const FlavorCost = Ember.Object.extend({

    billable: Em.computed.alias(setting('allow_billings')),

    fullFavor: Em.computed.alias('flavor.value'),

    favorSplitter() {
        const ffavor = this.get('fullFavor');
        if (!Ember.isEmpty(ffavor)) {
            return ffavor.split(',')
        }
        return [];
    },

    _splitAt(idx) {
        const splitFavor = this.favorSplitter();
        return splitFavor.length > 0 ? splitFavor[idx] : "";
    },

    cpu() {
        return this._splitAt(0);
    },

    memory() {
        return this._splitAt(1);
    },

    storage() {
        return this._splitAt(2);
    },

    valueAt(unitType) {
        if (this.billable) {
            const unitVals = Ember.tryInvoke(this, unitType);
            if (unitVals) {
                const unitVal = Ember.String.w(unitVals).filter(item => {
                      return  item.match(/[^a-zA-Z]+/);
                });

                if (!Ember.isEmpty(unitVal)) {
                    const unit_formatted = parseFloat(unitVal[0], 10).toFixed(4);
                    if (unit_formatted) {
                        return unit_formatted;
                    }
                }
            }
        }
        return 0;
    },

    valueFor(unitType, costPerUnit) {
        if (this.billable) {
            const units = this.valueAt(unitType);
            const unitCost = this.get(costPerUnit);

            const total = units * unitCost;
            return parseFloat(total, 10).toFixed(4);
        }
        return 0;
    },

    cpuPrice() {
        return this.valueFor('cpu', 'cpu_cost_per_hour');
    },

    memoryPrice() {
        return this.valueFor('memory', 'memory_cost_per_hour');
    },

    storagePrice() {
        return this.valueFor('storage', 'storage_cost_per_hour');
    },

    unitCostPerHour() {
        const price = parseFloat(this.cpuPrice(), 10)  +
                      parseFloat(this.memoryPrice(),10)  +
                      parseFloat(this.storagePrice(),10);

        return price.toFixed(3);
    },

    unitCostPerMonth() {
        const price = this.unitCostPerHour() * 24 * 30;
        return Math.round(price, -2);
    }
});


FlavorCost.reopenClass({

    flavoursMap(flav) {
        var flavorArray = [];

        for (var key in flav) {
            if (flav.hasOwnProperty(key) && key !== "toString") {
                flavorArray.push({
                    key: key,
                    value: flav[key]
                });
            }
        }
        return flavorArray;
    },

    all(resource) {
        if (this.units) {
            if (resource.name == this.units.get('firstObject').name) {  return this.units; }
        }

        var units = this.units = Em.A();
        this.flavoursMap(resource.flavors).forEach(function(flav) {
            //  if (Nilavu.SiteSettings["enable_region_" + name]) {

            var params = {
                name: resource.name,
                flavor: flav,
                currency: resource.currency,
                cpu_cost_per_hour: resource.cpu_cost_per_hour,
                memory_cost_per_hour: resource.ram_cost_per_hour,
                storage_cost_per_hour: resource.storage_cost_per_hour
            };

            units.pushObject(FlavorCost.create(params));
            //}
        });
        return units;
    }
});

export default FlavorCost;
