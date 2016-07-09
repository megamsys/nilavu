import NilavuURL from 'nilavu/lib/url';
import {
    default as computed,
    observes
} from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({
    tagName: 'div',
    classNameBindings: [':tab-pane', 'isActive:active'],

    isActive: function() {
        const selTab = this.get('selectedTab');
        return selTab.trim().length > 0 && selTab.trim() == 'prepackaged';
    }.property('selectedTab', 'selectedPackApp'),

    category: function() {
        return this.get('category');
    }.property("category"),

    //says if its vm or container
    @observes('prepackageble')
    prepackageChanged: function() {
        this.set('category.prepackageoption', this.get('prepackageble'));
    }
});
