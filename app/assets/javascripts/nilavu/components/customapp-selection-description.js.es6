import NilavuURL from 'nilavu/lib/url';
import {
    default as computed,
    observes
} from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({

    category: function() {
        return this.get('category');
    }.property("category"),

    appTitle: function() {
        if (this.get('category.customappoption')) {
            return this.get('category.customappoption') + " : " + this.get('category.customappversion');
        }
        return 'None';
    }.property('category.customappoption', 'category.customappversion'),


    appUrl: function() {
        var url = "general url";

        if (this.get('category.customappoption')) {
            url += '+ category.customappurl';
        }
        return url;
    }.property('category.customappoption', 'category.customappversion'),


    appDescription: function() {
        var desc = 'I18n(customapp.description)';

        if (this.get('category.customappoption')) {
            desc += 'I18n(customapp' + this.get('category.customappoption') + '.description)';
        }
        return desc;
    }.property('category.customappoption', 'category.customappversion')

});
