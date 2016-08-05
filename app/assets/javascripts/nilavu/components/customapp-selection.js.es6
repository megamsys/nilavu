import NilavuURL from 'nilavu/lib/url';

import {
    default as computed,
    observes
} from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({
    appDetails: null,
    appVersions: [],

    category: function() {
        return this.get('category');
    }.property("category"),

    comboVisible: function() {
        if (!Em.isEmpty(this.get("selectedItem"))) {
            return false;
        } else {
            return true;
        }
    }.property(),

    selectedItemLogo: function() {
        if (!Em.isEmpty(this.get("selectedItem"))) {
            return '../images/brands/' + this.get('selectedItem').image;
        }
    }.property(),

    customAppsChanged: function() {
        if (this.get('category.cooking.customapps')) {
            let i = 0;
            const ccids = this.get('category.cooking.customapps').map(function(e) {
                e.id = ++i;
                return e;
            });
            this.set('customapps', ccids);
        }
        if (!Em.isEmpty(this.get("selectedItem"))) {
            this.set('category.customappname', this.get('selectedItem.flavor'));
        }
    }.observes('category.cooking'),

    appVersionsForOption: function() {
        if (this.get('category.customappoption') && this.get('customapps')) {
            const filtApp = this.get('customapps').filter((f) => f.id == this.get('category.customappoption'));
            if (filtApp.get('firstObject')) {
                this.set('appVersions', filtApp.get('firstObject').versions);
            }
        }
    }.observes("category.customappoption"),

    appVersionsForName: function() {
        if (!Em.isEmpty(this.get("selectedItem")) && !Em.isEmpty(this.get('customapps'))) {
            const filtApp = this.get('customapps').filter((f) => f.name == this.get('selectedItem.flavor'));
            if (filtApp.get('firstObject')) {
                this.set('category.appDetail', filtApp.get('firstObject'));
                this.set('appVersions', filtApp.get('firstObject').versions);
            }
        }
    }.observes("category.customappname"),

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
