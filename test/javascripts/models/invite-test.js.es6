import Invite from 'nilavu/models/invite';

module("model:invite");

test("create", function() {
  ok(Invite.create(), "it can be created without arguments");
});
