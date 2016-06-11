import NilavuURL from 'nilavu/lib/url';

// This route is used for retrieving a topic/:id based on params - id
export default Nilavu.Route.extend({

  // Avoid default model hook
  model(params) { return params; },

  setupController(controller, params) {
    params = params || {};
    const self = this,
          topic = this.modelFor('topic'),
          topicController = this.controllerFor('topic');

    params.forceLoad = true;

    //TO-DO RAJ: ADD error handling here to show the error.
    const promise =  topic.reload().then(function(result) {
        topicController.setProperties({ model: topic });

        //  self.set('loading', false);
    }).catch(function(e) {
      alert("ERR="+ e);
      //self.set('loading', false);
    });

    self.controllerFor('navigation/default').set('filterMode', "top");
  },

  renderTemplate() {
    this.render('navigation/default', {
     outlet: 'navigation-bar'
    });

    this.render('topic/show', {
      controller: 'topic',
      outlet: 'list-container'
    });
  }

});
