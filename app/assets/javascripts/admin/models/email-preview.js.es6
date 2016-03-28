const EmailPreview = Nilavu.Model.extend({});

EmailPreview.reopenClass({
  findDigest: function(lastSeenAt, username) {

    if (Em.isEmpty(lastSeenAt)) {
      lastSeenAt = moment().subtract(7, 'days').format('YYYY-MM-DD');
    }

    if (Em.isEmpty(username)) {
      username = Nilavu.User.current().username;
    }

    return Nilavu.ajax("/admin/email/preview-digest.json", {
      data: { last_seen_at: lastSeenAt, username: username }
    }).then(function (result) {
      return EmailPreview.create(result);
    });
  }
});

export default EmailPreview;
