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
    resources: [],

    _initPanels: function() {
        this.set('panels', []);
        this.set('selectedTab', 'hourly');
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

    // _initPanels: function() {}.on('init'),

    regions: Ember.computed.alias('model.regions'),

    subRegionOption: function() {
        if (this.get('regions'))
            return this.get('regions.firstObject.name');

        return "";
    }.property('regions'),

    regionChanged: function() {
        if (!this.get('regions')) {
            return;
        }
        const _regionOption = this.get('subRegionOption');

        const fullFlavor = this.get('regions').filter(function(c) {
            if (c.name == _regionOption) {
                return c;
            }
        });
        if (fullFlavor.length > 0) {
            this.set('model.subresource', fullFlavor.get('firstObject'));
        }
    }.observes('model.subregion'),

    actions: {},


});
