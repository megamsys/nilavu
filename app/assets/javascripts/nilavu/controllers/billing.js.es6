import NilavuURL from 'nilavu/lib/url';
import computed from "ember-addons/ember-computed-decorators";

export default Ember.Controller.extend({
    title: "Billing",
    formSubmitted: false,

    regions: Ember.computed.alias('model.regions'),

    transactions: Ember.computed.alias('model.transactions'),

    resources: [],

    submitDisabled: function() {
        if (this.get('formSubmitted')) return true;

        return false;
    }.property('formSubmitted'),


    //send the default region
    billingRegionOption: function() {
        if (this.get('regions')) return this.get('regions.firstObject.name');

        return "";
    }.property('regions'),

    regionChanged: function() {
        if (!this.get('regions')) {
            return;
        }
        const _regionOption = this.get('billingRegionOption');

        const fullFlavor = this.get('regions').filter(function(c) {
            if (c.name == _regionOption) {
                return c;
            }
        });
        if (fullFlavor.length > 0) {
            this.set('model.billresource', fullFlavor.get('firstObject'));
        }
    }.observes('model.billregion'),

    supportEmail: function() {
        return Nilavu.SiteSettings.support_email;
    }.property(),

    supportPhoneNumber: function() {
        return Nilavu.SiteSettings.support_phonenumber;
    }.property(),

    //This has to be generic as we would support multiple billers
    whmcsClientAreaRedirect: function() {
        return Nilavu.SiteSettings.whmcs_clientarea_url;
    }.property(),

    actions: {
        addFunds: function() {
            this.set('formSubmitted', true);
            NilavuURL.redirectTo(this.get('whmcsClientAreaRedirect'));
            this.set('formSubmitted', false);
        }

    }
});
