import NilavuURL from 'nilavu/lib/url';

export default Ember.Controller.extend({
    title: "Billing",
    currentUsage: Ember.computed.alias('model.usage'),
    currentBalance: Ember.computed.alias('model.balance'),
    regions: Ember.computed.alias('model.regions'),

    //send the default region
    billingRegionoption: function() {
        if (this.get('regions')) {
            return this.get('regions.firstObject.name')
        }
        return;
    }.property('regions'),

    resources: function() {
        if (!this.get('regions')) {
            return;
        }
        const _regionOption = this.get('billingRegionoption');
        const fullFlavor = this.get('regions').filter(function(c) {
            if (c.name == _regionOption) {
                return c;

            }
        });
        if (fullFlavor.length > 0) {
            this.set('unitFlavors', fullFlavor.get('firstObject').flavors);
        }
    }.observes('billingRegionoption'),

});
