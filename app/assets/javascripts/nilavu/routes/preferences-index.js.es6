import RestrictedUserRoute from "nilavu/routes/restricted-user";

export default RestrictedUserRoute.extend({
  renderTemplate: function() {
    this.render('preferences', { into: 'user', controller: 'preferences' });
  }
});
