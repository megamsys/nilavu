import { iconNode } from 'nilavu/helpers/fa-icon';

export default Ember.Component.extend({

    rerenderTriggers: ['flavorcost'],

    resourceChanged: function() {
        this.set('flavorcost', this.get('model.flavorcost'));
    }.observes('model.flavorcost'),

    //first time round, currency will be empty.
    currency: function() {
        const regionCurrency = this.get('flavorcost.currency');
        if (regionCurrency) {
            return new Handlebars.SafeString(regionCurrency);
        }
        return "$"
    }.property('flavorcost'),

    currentUsage: Ember.computed.alias('model.usage'),

    currentBalance: Ember.computed.alias('model.paid')


});
