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
    resendSubmitted: false,
    selectedTab: null,
    panels: null,
    showTop: false,
    addresssValidated: false,
    subscriber: Ember.computed.alias('model.addon.result'),
    mobavatar: Ember.computed.alias('model.mobavatar_activation.success'),
    phoneNumber: Ember.computed.alias('currentUser.phone'),

    @observes('subscriber')subscriberChecker: function() {
        console.log(this.get('subscriber'));
        console.log(this.get("mobavatar"));
    },

    _initPanels: function() {
        this.set('panels', []);
        this.set('selectedTab', 'monthly');
    }.on('init'),

    externalIdCheck: function() {
      if(this.get("subscriber") == 'success')
      {
        return true;
      }
      return false;
    }.property('subscriber'),

    hourlySelected: function() {
        return this.selectedTab == 'hourly';
    }.property('selectedTab'),

    monthlySelected: function() {
        return this.selectedTab == 'monthly';
    }.property('selectedTab'),

    title: function() {
        return 'Subscriptions';
    }.property('model'),

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
          this.set('otpSubmitted', true);
            const self = this,
                attrs = this.getProperties('otpNumber');
            return Nilavu.ajax("/verify/otp", {
                data: {
                    otp: attrs.otpNumber
                },
                type: 'POST'
            }).then(function(result) {
              self.set('otpSubmitted', false);
                self.setProperties({otpNumber: ''});
                if (result.success) {
                    self.notificationMessages.success(I18n.t("user.activation.activate_phone_activated"));
                }

                if (!result.success) {
                    self.notificationMessages.error(I18n.t("user.activation.activate_phone_error"));
                }
            });
        },

        resendOTP() {
          this.set('resendSubmitted', true);
            const self = this,
            attrs = this.getProperties('phoneNumber');
            return Nilavu.ajax("/resendOTP", {
                data: {
                  phone: attrs.phoneNumber

                },
                type: 'POST'
            }).then(function(result) {
                self.set('resendSubmitted', false);
                if (result.success) {
                    self.notificationMessages.success(I18n.t("user.activation.opt_send"));
                }
                if (!result.success) {
                    self.notificationMessages.error(I18n.t("user.activation.opt_send_error"));
                }
            });
        }
    },

    hasError: Ember.computed.or('model.notFoundHtml', 'model.message'),

    noErrorYet: Ember.computed.not('hasError')

});
