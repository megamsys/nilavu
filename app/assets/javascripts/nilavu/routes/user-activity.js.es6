export default Nilavu.Route.extend({
  model() {
    return this.modelFor("user");
  },

  setupController(controller, user) {
    this.controllerFor("user-activity").set("model", user);
  }
});
