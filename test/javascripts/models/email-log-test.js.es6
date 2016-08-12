import EmailLog from 'admin/models/email-log';

module("Nilavu.EmailLog");

test("create", function() {
  ok(EmailLog.create(), "it can be created without arguments");
});
