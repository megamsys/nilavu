import NilavuURL from 'nilavu/lib/url';

// This route is used for retrieving a topic based on params
export default Nilavu.Route.extend({

  // Avoid default model hook
  model(params) { return params; },

  setupController(controller, params) {
    params = params || {};
    const self = this,
          topic = this.modelFor('topic'),
          topicController = this.controllerFor('topic');

    params.forceLoad = true;
    topic.reload();
    alert(JSON.stringify(topic));
    topicController.setProperties({ model: topic });

  }

});
