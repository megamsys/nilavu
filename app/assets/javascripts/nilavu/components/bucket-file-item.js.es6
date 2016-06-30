export default Ember.Component.extend({

  sizeWithUnits: function() {
      return this.model.size;
  }.property(),

});
