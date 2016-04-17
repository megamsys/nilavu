export default Nilavu.Route.extend({
  beforeModel: function() {
    this.transitionTo('adminUsersList.show', 'active');
  }
});
