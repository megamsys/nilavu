export default Nilavu.Route.extend({
  controllerName: 'user-notifications',

  redirect() {
      return this.redirectIfLoginRequired();
  },

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
