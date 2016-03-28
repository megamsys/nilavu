export default Nilavu.Route.extend({
  model: function() {
    return Nilavu.ajax("/admin/customize/emojis.json").then(function(emojis) {
      return emojis.map(function (emoji) { return Ember.Object.create(emoji); });
    });
  }
});
