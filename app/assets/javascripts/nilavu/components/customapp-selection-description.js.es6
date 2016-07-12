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
        if (this.get('category.customappname')) {
            return this.get('category.customappname') + "  Version " + this.get('category.customappversion');
        }
        return 'None';
    }.property('category.customappname', 'category.customappversion'),


    appUrl: function() {
        return Nilavu.SiteSettings.faq_url;
    }.property('category.appDetails'),

    appUrlTitle: function() {
        return I18n.t('customapp.docs');
    }.property('category.appDetails'),


    appDescription: function() {
        return I18n.t('customapp.description');
    }.property('category.appDetails')

});
