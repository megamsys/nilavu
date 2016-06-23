import NilavuURL from 'nilavu/lib/url';
import {     default as computed,      observes  } from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({

    category: function() {
        return this.get('category');
    }.property("category"),

    @observes('prepackageble')
    prepackageChanged: function() {
        this.set('category.prepakageoption', this.get('prepackageble'));
    }
});
