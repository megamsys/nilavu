import BufferedContent from 'nilavu/mixins/buffered-content';
import {spinnerHTML} from 'nilavu/helpers/loading-spinner';
import Subscriptions from 'nilavu/models/subscriptions';
import {popupAjaxError} from 'nilavu/lib/ajax-error';
import {observes, computed} from 'ember-addons/ember-computed-decorators';
import NilavuURL from 'nilavu/lib/url';
import {setting} from 'nilavu/lib/computed';
import {on} from 'ember-addons/ember-computed-decorators';
import debounce from 'nilavu/lib/debounce';

export default Ember.Controller.extend(BufferedContent, {
    needs: ['application'],
    loading: false,
    formSubmitted: false,
    otpSubmitted: false,
    selectedTab: null,
    panels: null,
    showTop: false,
    subscriber: Ember.computed.alias('model.subscriber'),
    mobavatar: Ember.computed.alias('model.mobavatar_activation'),

    @observes('subscriber')subscriberChecker: function() {
        console.log(this.get('subscriber'));
        console.log(this.get("mobavatar"));
    },

    _initPanels: function() {
        this.set('panels', []);
        this.set('selectedTab', 'monthly');
    }.on('init'),

    hourlySelected: function() {
        return this.selectedTab == 'hourly';
    }.property('selectedTab'),

    monthlySelected: function() {
        return this.selectedTab == 'monthly';
    }.property('selectedTab'),

    title: function() {
        return 'Subscriptions';
    }.property('model'),

    phoneNumber: function() {
        return "+61 422 101 421";
    }.property(),

    // _initPanels: function() {}.on('init'),

    orderedCatTypes: function() {
        const grouped_results = this.get('model.results');

        let otmap = [];

        for (var order in grouped_results) {
            otmap.push({order: order, cattype: grouped_results[order].get('firstObject.cattype').toLowerCase()});
        }

        return otmap;
    }.property('model.results'),

    submitDisabled: function() {
        if (Ember.isEmpty(this.get('address')))
            return true;
        if (Ember.isEmpty(this.get('city')))
            return true;
        if (Ember.isEmpty(this.get('state')))
            return true;
        if (Ember.isEmpty(this.get('zipcode')))
            return true;
        if (Ember.isEmpty(this.get('company')))
            return true;

        return false;
    }.property('address', 'city', 'state', 'zipcode', 'company'),

    otpDisabled: function() {
        if (Ember.isEmpty(this.get('otpNumber')))
            return true;
        return false;
    }.property('otpNumber'),

    actions: {
        activate() {
            const self = this,
                attrs = this.getProperties('address', 'address2', 'city', 'state', 'zipcode', 'company');
            this.set('formSubmitted', true);

            return Nilavu.ajax("/subscriptions", {
                data: {
                    address1: attrs.address,
                    address2: attrs.address2,
                    city: attrs.city,
                    state: attrs.state,
                    postcode: attrs.zipcode,
                    companyname: attrs.company
                },
                type: 'POST'
            }).then(function(result) {
                self.set('formSubmitted', false);
                var rs = result.subscriber;
                if (Em.isEqual(rs.result, "success")) {
                    NilavuURL.routeTo('/billers/bill/activation');
                } else {
                    console.log(JSON.stringify(rs));
                    self.notificationMessages.error(I18n.t(rs.error));
                }
            });
        },

        verifyOTP() {
            const self = this,
                attrs = this.getProperties('otpNumber');
            this.set('otpSubmitted', true);
            return Nilavu.ajax("/verify/otp", {
                data: {
                    otp: attrs.otpNumber
                },
                type: 'POST'
            }).then(function(result) {
                self.set('otpSubmitted', false);
                self.setProperties({otpNumber: ''});

                if (!result.success) {
                    self.notificationMessages.error(I18n.t("user.activation.activate_phone_error"));
                }
            });
        }
    },

    hasError: Ember.computed.or('model.notFoundHtml', 'model.message'),

    noErrorYet: Ember.computed.not('hasError')

});
