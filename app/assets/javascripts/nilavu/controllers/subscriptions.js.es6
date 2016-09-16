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
    createAddonSubmitted: false,
    addresssValidated: false,
    subscriber: Ember.computed.alias('model.addon.result'),
    mobavatar: Ember.computed.alias('model.mobavatar_activation.success'),
    phoneNumber: Ember.computed.alias('currentUser.phone'),

    address1: function() {
        return Nilavu.SiteSettings.address1;
    }.property(),
    city: function() {
        return Nilavu.SiteSettings.city;
    }.property(),
    state: function() {
        return Nilavu.SiteSettings.state;
    }.property(),
    postcode: function() {
        return Nilavu.SiteSettings.postcode;
    }.property(),
    country: function() {
        return Nilavu.SiteSettings.country;
    }.property(),
    password2: function() {
        return Nilavu.SiteSettings.password2;
    }.property(),

    @observes('subscriber')subscriberChecker: function() {
        console.log(this.get('subscriber'));
        console.log(this.get("mobavatar"));
    },

    _initPanels: function() {
        this.set('panels', []);
        this.set('selectedTab', 'monthly');
    }.on('init'),

    externalIdCheck: function() {
        if (this.get("subscriber") == 'success') {
            return false;
        }
        this.set('addresssValidated', true);
        return true;
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
        if (Ember.isEmpty(this.get('country')))
            return true;

        return false;
    }.property('address', 'city', 'state', 'zipcode', 'company', 'country'),

    otpDisabled: function() {
        if (Ember.isEmpty(this.get('otpNumber')))
            return true;
        return false;
    }.property('otpNumber'),

    actions: {
        activate() {
            const self = this,
                attrs = this.getProperties('address', 'address2', 'city', 'state', 'zipcode', 'company', 'country');
            this.set('formSubmitted', true);

            return Nilavu.ajax("/subscriptions", {
                data: {
                    address1: attrs.address,
                    address2: attrs.address2,
                    city: attrs.city,
                    state: attrs.state,
                    postcode: attrs.zipcode,
                    companyname: attrs.company,
                    country: attrs.country
                },
                type: 'POST'
            }).then(function(result) {
                self.set('formSubmitted', false);
                var rs = result.subscriber;
                if (Em.isEqual(rs.result, "success")) {
                    NilavuURL.routeTo('/billers/bill/activation');
                } else {
                    console.log(JSON.stringify(rs));
                    self.notificationMessages.error(rs.message);
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
                    self.notificationMessages.success(I18n.t("user.activation.otp_sent"));
                }
                if (!result.success) {
                    self.notificationMessages.error(I18n.t("user.activation.otp_send_error"));
                }
            });
        },

        createAddon() {
            console.log(JSON.stringify(Nilavu.SiteSettings));

            this.set('createAddonSubmitted', true);
            const self = this;
            return Nilavu.ajax("/addon", {
                data: {
                    firstname: this.get('currentUser.first_name'),
                    lastname: this.get('currentUser.last_name'),
                    address1: this.get('address1'),
                    city: this.get('city'),
                    state: this.get('state'),
                    postcode: this.get('postcode'),
                    country: this.get('country'),
                    phonenumber: this.get('currentUser.phone'),
                    password2: this.get('password2'),
                },
                type: 'POST'
            }).then(function(result) {
                self.set('createAddonSubmitted', false);
                var rs = result.addon.parms;
                if (Em.isEqual(rs.account_id, self.get('currentUser.email'))) {
                    self.set('addresssValidated', false);
                    self.set('externalIdCheck', false);
                    self.notificationMessages.success(I18n.t("user.activation.addon_onboard_success"));
                }
                if (Em.isEqual(result.result, "error")) {
                    self.notificationMessages.error(I18n.t(result.error));
                }
            });
        }
    },

    hasError: Ember.computed.or('model.notFoundHtml', 'model.message'),

    noErrorYet: Ember.computed.not('hasError')

});
