import NilavuURL from 'nilavu/lib/url';

import {
    default as computed,
    observes
} from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({
    tagName: 'div',
    classNameBindings: [':tab-pane', 'isActive:active'],

    category: function() {
        return this.get('category');
    }.property("category"),

    repoChanged: function() {
        this.set('category.versionoption', this.get('category.customappversion'));
        this.set('category.versiondetail', this.get('category.repoDetail'));
    }.observes('category.selectedrepo','category.customappname', 'category.customappversion'),

    isActive: function() {
        const selTab = this.get('selectedTab');
        return selTab.trim().length > 0 && selTab.trim() == 'customapp';
    }.property('selectedTab', 'selectedPackApp')


});
