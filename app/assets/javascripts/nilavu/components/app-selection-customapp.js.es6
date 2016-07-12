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

    dashedAppName: function() {
        if (this.get('category.customappname') && this.get('category.customappversion')) {
            return (this.get('category.customappname') + "_" + this.get('category.customappversion'));
        }
        return "";
    }.property('category.customappname', 'category.customappversion'),

    repoChanged: function() {
        this.set('category.versionoption', this.get('dashedAppName'));
        this.set('category.versiondetail', this.get('category.appDetail'));
        this.set('category.customapprepo', this.get('category.repoDetail'));
    }.observes('category.customappname', 'category.customappversion', 'category.appDetail', 'category.repoDetail'),

    isActive: function() {
        const selTab = this.get('selectedTab');
        return selTab.trim().length > 0 && selTab.trim() == 'customapp';
    }.property('selectedTab', 'selectedPackApp')


});
