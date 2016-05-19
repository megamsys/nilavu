import {  observes } from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({

    unitFlavourChanged: function() {
        this.set('unitFlav', this.get('category.unitoption'));
        this.rerender();
    }.observes('category.unitoption'),

    currency: function() {
      const  regionCurrency =  this.get('unitFlav.currency');
      if (regionCurrency) {
        return new Handlebars.SafeString(regionCurrency);
      }
      return new Handlebars.SafeString(this.get('category.currency_denoted'));
    }.property('unitFlav','category.currency_denoted'),

    unitPerHour: function() {
        const uf = this.get('unitFlav');
        return uf ? uf.unitCostPerHour() : 0;
    }.property('category.unitoption', 'unitFlav'),

    unitPerMonth: function() {
        const uf = this.get('unitFlav');
        return uf ? uf.unitCostPerMonth() : 0;
    }.property('category.unitoption','unitFlav')


});
