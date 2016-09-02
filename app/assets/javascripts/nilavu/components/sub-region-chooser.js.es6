import { on, observes } from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({

    subRegionChanged: function() {
       this.set('model.subregion', this.get('subRegionOption'));
    },

    change: function() {
        Ember.run.once(this, 'subRegionChanged');
    },

});
