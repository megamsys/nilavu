export default Nilavu.Route.extend({
  model: function() {
    return Nilavu.ajax("/404-body", { dataType: 'html' });
  }
});
