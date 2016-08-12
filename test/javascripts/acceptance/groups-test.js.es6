import { acceptance } from "helpers/qunit-helpers";
acceptance("Groups");

test("Browsing Groups", () => {
  visit("/groups/discourse");
  andThen(() => {
    ok(count('.group-members tr') > 0, "it lists group members");
  });

  visit("/groups/nilavu/posts");
  andThen(() => {
    ok(count('.user-stream .item') > 0, "it lists stream items");
  });

  visit("/groups/nilavu/topics");
  andThen(() => {
    ok(count('.user-stream .item') > 0, "it lists stream items");
  });

  visit("/groups/nilavu/mentions");
  andThen(() => {
    ok(count('.user-stream .item') > 0, "it lists stream items");
  });

  visit("/groups/nilavu/messages");
  andThen(() => {
    ok(count('.user-stream .item') > 0, "it lists stream items");
  });
});
