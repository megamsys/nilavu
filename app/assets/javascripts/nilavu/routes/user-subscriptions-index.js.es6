export default Nilavu.Route.extend({
  redirect() {
      return this.redirectIfLoginRequired();
  },

  renderTemplate() {},

  actions: {
    didTransition() {
      this.controllerFor("user-subscriptions")._showFooter();
      return true;
    }
  },

  model() {
    const email = this.modelFor("user").get("email");

    if (this.get("currentUser.email") ===  email || this.get("currentUser.admin")) {
      return this.store.find("subscriptions", { email } );
    }
  },


  setupController(controller, model) {
    controller.set("model", model);
    controller.set("user", this.modelFor("user"));
  }
});
