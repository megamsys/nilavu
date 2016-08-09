import BufferedContent from 'nilavu/mixins/buffered-content';
import {spinnerHTML} from 'nilavu/helpers/loading-spinner';
import Marketplaces from 'nilavu/models/marketplaces';
import {popupAjaxError} from 'nilavu/lib/ajax-error';
import computed from 'ember-addons/ember-computed-decorators';
import showModal from 'nilavu/lib/show-modal';

import OpenComposer from "nilavu/mixins/open-composer";

export default Ember.Controller.extend(BufferedContent, OpenComposer, {
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

        createTopic(item) {
            const self = this;
            var itemOption = "applications";
            // Don't show  if we're still loading, may be show a growl.
            if (self.get('loading')) {
                return;
            }
            if (Ember.isEqual(item.cattype, 'TORPEDO'))
                itemOption = "virtualmachines";
            self.set('loading', true);
            const promise = self.openComposer(self.controllerFor("discovery/topics")).then(function(result) {
                self.set('loading', false);
                showModal('editCategory', {
                    model: result,
                    smallTitle: false,
                    titleCentered: true
                }).setProperties({marketplaceItem: item, selectedItemOption: itemOption});
            }).catch(function(e) {
                self.set('loading', false);
            });
        }
    },

    hasError: Ember.computed.or('model.notFoundHtml', 'model.message'),

    noErrorYet: Ember.computed.not('hasError')

});
