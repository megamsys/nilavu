import BufferedContent from 'nilavu/mixins/buffered-content';
import { spinnerHTML } from 'nilavu/helpers/loading-spinner';
import Marketplaces from 'nilavu/models/marketplaces';
import { popupAjaxError } from 'nilavu/lib/ajax-error';
import computed from 'ember-addons/ember-computed-decorators';

export default Ember.Controller.extend(BufferedContent, {
    needs: ['application'],
    loading: false,

    title: function() {
        return 'Marketplaces';
    }.property('model'),

    _initPanels: function() {}.on('init'),

    orderedCatTypes: function() {
        const grouped_results = this.get('model.results');

        let otmap = [];

        for (var order in grouped_results) {
            otmap.push({order: order, cattype: grouped_results[order].get('firstObject.cattype').toLowerCase()});
        }

        return otmap;
    }.property('model.results'),



    //check the freewheeling site setting flag for true or false
    minifiedVersion: function() {
        return false;
    }.property('selectedTab'),


    actions: {

        showMarketplaceItem() {
            alert('showMakitem');
        },


        save() {},

    },

    hasError: Ember.computed.or('model.notFoundHtml', 'model.message'),

    noErrorYet: Ember.computed.not('hasError')

});
