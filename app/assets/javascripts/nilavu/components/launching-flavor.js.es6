import {
    on,
    observes,
    computed
} from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({

    unitFlav: function() {
        return this.get('flavor');
    }.property('flavor'),

    flavorName: Em.computed.alias('unitFlav.flavor.key'),

    fcpu: function() {
        return this.get('unitFlav').cpu();
    }.property('unitFlav.cpu'),

    fmemory: function() {
        return this.get('unitFlav').memory();
    }.property('unitFlav.memory'),

    fstorage: function() {
        return this.get('unitFlav').storage();
    }.property('unitFlav.storage'),

    unitChanged: function() {
      this.set('category.unitoption', this.get('unitFlav'));
    },

    change: function() {      
      Ember.run.once(this, 'unitChanged');
    },

    @observes('flavor.@each')
    _rerenderOnChange() {
      this.rerender();
    }

});
