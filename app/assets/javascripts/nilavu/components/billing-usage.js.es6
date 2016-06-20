export default Ember.Component.extend({

  currentUsage:  Ember.computed.alias('model.usage'),

  currentBalance: 90 //Ember.computed.alias('model.balance'),

});
