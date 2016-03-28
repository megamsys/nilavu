import EmailSettings from 'admin/models/email-settings';

export default Nilavu.Route.extend({
  model() {
    return EmailSettings.find();
  },

  renderTemplate() {
    this.render('admin/templates/email_index', { into: 'adminEmail' });
  }
});
