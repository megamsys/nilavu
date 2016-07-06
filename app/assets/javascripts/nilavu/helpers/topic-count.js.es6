Ember.Handlebars.registerBoundHelper('topic-count', function(topics, category) {
  var count = 0;
  if (topics === undefined || topics.length > 0) {
      for (var i = 0; i < topics.length; i++) {
          if (topics[i].tosca_type.split(".")[1] == category) count++;
      }
  }
  return count;
});
