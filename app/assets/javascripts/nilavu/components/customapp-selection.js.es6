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

    appVersions: function() {
        var rval = [];
        //_.each(this.get("sshoptions"), function(p) {
        if (this.get('category.customappoption')) {
            rval.addObject({
                name: '4.4 memo',
                value: '4.4 memo'
            });

            rval.addObject({
                name: '6.6 aaaaaa',
                value: '6.6 aaaaaaa'
            });
            //  });
        }
        return rval;
    }.property("category.customappoption"),

    selectedAppChanged: function() {
        this.set('category.customappoption', this.get('selectedApp'));
    }.observes('selectedApp'),

    selectedAppVersionChanged: function() {
        this.set('category.customappversion', this.get('selectedAppVersion'));
    }.observes('selectedAppVersion')

});
