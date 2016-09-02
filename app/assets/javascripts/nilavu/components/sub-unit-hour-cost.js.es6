import { on, observes, computed } from 'ember-addons/ember-computed-decorators';
import FlavorCost from 'nilavu/models/flavor_cost';
export default Ember.Component.extend({

  unitFlav: function() {
      const fc = FlavorCost.all(this.get('model.subresource'));
      if (!Ember.isEmpty(fc) && fc.length > 0) {
          const propagate = fc.objectAt(0);
          this.set('model.flavorcost', propagate);
          return propagate;
      }
      return;
  }.property('model.subresource','flavorcost'),

    resourceChanged: function() {
        this.set('flavorcost', this.get('unitFlav'));
    }.observes('model.flavorcost'),

    currency: function() {
        const regionCurrency = this.get('unitFlav.currency');
        if (regionCurrency) {
            return new Handlebars.SafeString(regionCurrency);
        }
    }.property('flavorcost', 'unitFlav.currency'),

    totalHourlyCost: function() {
        return this.get('unitFlav').unitCostPerHour();
    }.property('flavorcost','unitFlav'),

    _rerenderOnChange: function() {
        this.rerender();
    }.observes('totalHourlyCost')

})
