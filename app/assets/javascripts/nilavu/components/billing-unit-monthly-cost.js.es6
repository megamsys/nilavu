import FlavorCost from 'nilavu/models/flavor_cost';

export default Ember.Component.extend({

    resourceChanged: function() {
        this.set('flavorcost', this.get('model.flavorcost'));
    }.observes('model.flavorcost'),

    currency: function() {
        const regionCurrency = this.get('flavorcost.currency');
        if (regionCurrency) {
            return new Handlebars.SafeString(regionCurrency);
        }
    }.property('flavorcost'),

    hourlyCpuCost: function() {
        return this.get('flavorcost').cpuPrice();
    }.property('flavorcost'),

    hourlyMemoryCost: function() {
        return this.get('flavorcost').memoryPrice();
    }.property('flavorcost'),

    hourlyStorageCost: function() {
        return this.get('flavorcost').storagePrice();
    }.property('flavorcost'),

    _rerenderOnChange: function() {
        this.rerender();
    }.observes('flavorcost')
})
