const EmailSettings = Nilavu.Model.extend({});

EmailSettings.reopenClass({
  find: function() {
    return Nilavu.ajax("/admin/email.json").then(function (settings) {
      return EmailSettings.create(settings);
    });
  }
});

export default EmailSettings;
