export default Nilavu.Route.extend({
  controllerName: 'user-notifications',

  renderTemplate() {
    this.render('navigation/default', {
        outlet: 'navigation-bar'
    });

    this.render('user/notifications', {
        controller: 'user-notifications',
        outlet: 'list-container'
    });

  },


  afterModel(model){
    if (!model) {
      this.transitionTo('userNotifications.responses');
    }
  },
});
