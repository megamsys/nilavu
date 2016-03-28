import AdminUser from 'admin/models/admin-user';

const IncomingEmail = Nilavu.Model.extend({});

IncomingEmail.reopenClass({

  create(attrs) {
    attrs = attrs || {};

    if (attrs.user) {
      attrs.user = AdminUser.create(attrs.user);
    }

    return this._super(attrs);
  },

  find(id) {
    return Nilavu.ajax(`/admin/email/incoming/${id}.json`);
  },

  findAll(filter, offset) {
    filter = filter || {};
    offset = offset || 0;

    const status = filter.status || "received";
    filter = _.omit(filter, "status");

    return Nilavu.ajax(`/admin/email/${status}.json?offset=${offset}`, { data: filter })
                    .then(incomings => _.map(incomings, incoming => IncomingEmail.create(incoming)));
  },

  loadRawEmail(id) {
    return Nilavu.ajax(`/admin/email/incoming/${id}/raw.json`);
  }
});

export default IncomingEmail;
