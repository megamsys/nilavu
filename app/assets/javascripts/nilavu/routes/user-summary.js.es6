export default Nilavu.Route.extend({
  model() {
    return this.modelFor("User").summary();
  }
});
