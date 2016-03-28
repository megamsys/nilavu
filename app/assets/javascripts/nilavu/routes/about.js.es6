export default Nilavu.Route.extend({
  model() {
    return Nilavu.ajax("/about.json").then(result => result.about);
  },

  titleToken() {
    return I18n.t('about.simple_title');
  },

  actions: {
    didTransition() {
      this.controllerFor("application").set("showFooter", true);
      return true;
    }
  }
});
