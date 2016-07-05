import NilavuURL from 'nilavu/lib/url';

import {
    default as computed,
    observes
} from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({
    tagName: 'div',
    classNameBindings: [':tab-pane', 'isActive:active'],
    appDetails: null,

    category: function() {
        return this.get('category');
    }.property("category"),


    appDetailsChanged: function() {
      this.set('category.appdetails', this.get('appDetails'));
    }.property('appDetails'),

    repoChanged: function() {
      this.set('category.repotype', this.get('customRepoType'));
      this.set('category.selectedrepo', this.get('selectedRepo'));
    }.property('customRepoType', 'selectedRepo'),

    isActive: function() {
        const selTab = this.get('selectedTab');
        return selTab.trim().length > 0 && selTab.trim() == 'customapp';
    }.property('selectedTab', 'selectedPackApp')

});
