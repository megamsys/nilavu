export default Nilavu.Route.extend({
  redirect: function() {
    this.replaceWith('adminFlags.list', 'active');
  }
});
