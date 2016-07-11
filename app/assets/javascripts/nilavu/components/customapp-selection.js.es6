import NilavuURL from 'nilavu/lib/url';

import {
    default as computed,
    observes
} from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({
    appDetails: null,

    category: function() {
        return this.get('category');
    }.property("category"),

    customAppsChanged: function() {
        const cc = this.get('category.cooking.customapps');

        let i = 0;
        const ccids = cc.map(function(e) {
            e.id = ++i;
            return e;
        });
        this.set('customapps', ccids);
    }.observes('category.cooking'),

    appVersions: function() {
        if (this.get('category.customappoption') && this.get('customapps')) {
            const filtApp = this.get('customapps').filter((f) => f.id == this.get('category.customappoption'));
            if (filtApp.get('firstObject')) {
                return filtApp.get('firstObject').versions;
            }
        }
        return [];
    }.property("category.customappoption"),

    ndexToAppName: function(idx) {
        if (this.get('category.customappoption') && this.get('customapps')) {
            const filtApp = this.get('customapps').filter((f) => f.id == this.get('category.customappoption'));
            if (filtApp.get('firstObject')) {
                this.set('category.appDetail', filtApp.get('firstObject'));
                return filtApp.get('firstObject').name;
            }
        }
        return "";
    },

    selectedAppChanged: function() {
        this.set('category.customappoption', this.get('selectedApp'));
        this.set('category.customappname', this.ndexToAppName(this.get('selectedApp')));
    }.observes('selectedApp'),

    selectedAppVersionChanged: function() {
        this.set('category.customappversion', this.get('selectedAppVersion'));
    }.observes('selectedAppVersion')

});
