import BufferedContent from 'nilavu/mixins/buffered-content';
import {spinnerHTML} from 'nilavu/helpers/loading-spinner';
import Subscriptions from 'nilavu/models/subscriptions';
import {popupAjaxError} from 'nilavu/lib/ajax-error';
import {observes, computed} from 'ember-addons/ember-computed-decorators';
import NilavuURL from 'nilavu/lib/url';

export default Ember.Controller.extend(BufferedContent, {
    needs: ['application'],
    loading: false,
    formSubmitted: false,

    subscriber: Ember.computed.alias('model.subscriber'),
    mobavatar: Ember.computed.alias('model.mobavatar_activation'),

    @observes('subscriber')
    subscriberChecker: function() {
        console.log(this.get('subscriber'));
    },


    title: function() {
        return 'Subscriptions';
    }.property('model'),

    phoneNumber: function() {
        return "+61 422 101 421";
    }.property(),

    _initPanels: function() {}.on('init'),

    orderedCatTypes: function() {
        const grouped_results = this.get('model.results');

        let otmap = [];

        for (var order in grouped_results) {
            otmap.push({
                order: order,
                cattype: grouped_results[order].get('firstObject.cattype').toLowerCase()
            });
        }

        return otmap;
    }.property('model.results'),



    actions: {
        activate() {
            const self = this,
                attrs = this.getProperties('address', 'address2', 'city', 'state', 'zipcode', 'company');
            this.set('formSubmitted', true);
            //NilavuURL.routeTo('/subscriptions/bill/activation');
            return Nilavu.Subscriptions.createAccount(attrs).then(function(result) {
                self.set('isDeveloper', false);
                console.log("+++++++++++++++++++++++++++++++++++++++++");
                console.log(result);
            }, function() {
                self.set('formSubmitted', false);
                return self.flash(I18n.t('create_account.failed'), 'error');
            });
        },

    },

    hasError: Ember.computed.or('model.notFoundHtml', 'model.message'),

    noErrorYet: Ember.computed.not('hasError')

});
