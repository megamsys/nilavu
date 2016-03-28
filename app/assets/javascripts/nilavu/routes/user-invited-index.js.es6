export default Nilavu.Route.extend({
  beforeModel: function() {
    this.replaceWith('userInvited.show', 'pending');
  }
});
