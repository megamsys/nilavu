// This route is used for showing a predeploy for  a topic/:id/predeploy based on params - id
export default Nilavu.Route.extend({

  renderTemplate() {
    this.render('navigation/default', {
     outlet: 'navigation-bar'
    });

    this.render('topic/predeploy', {
      controller: 'topic',
      outlet: 'list-container'
    });
  }

});
