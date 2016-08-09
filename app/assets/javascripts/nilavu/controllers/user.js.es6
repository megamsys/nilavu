import CanCheckEmails from 'nilavu/mixins/can-check-emails';
import computed from 'ember-addons/ember-computed-decorators';
import UserAction from 'nilavu/models/user-action';
import User from 'nilavu/models/user';

export default Ember.Controller.extend({
    indexStream: false,
    userActionType: null,
    needs: [
        'application', 'user-notifications', 'user-topics-list'
    ],
    currentPath: Em.computed.alias('controllers.application.currentPath'),
    title: "My Profile",
    selectedTab: null,
    panels: null,
    rerenderTriggers: ['isUploading'],

    _initPanels: function() {
        this.set('panels', []);
        this.set('selectedTab', 'account');
    }.on('init'),

    accoutSelected: function() {
        return this.selectedTab == 'account';
    }.property('selectedTab'),

    organizationSelected: function() {
        return this.selectedTab == 'organization';
    }.property('selectedTab'),

    apikeySelected: function() {
        return this.selectedTab == 'apikey';
    }.property('selectedTab'),

    organizationType: function() {
        const grouped_results = this.get('model.details');

        let otmap = [];

        for (var order in grouped_results) {
            otmap.push({order: order, name: grouped_results[order].get('firstObject.name')});
        }
        return otmap;
    }.property('model.details')
});
