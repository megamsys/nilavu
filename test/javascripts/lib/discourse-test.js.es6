module("lib:discourse");

test("getURL on subfolder install", function() {
  Nilavu.BaseUri = "/forum";
  equal(Nilavu.getURL("/"), "/forum/", "root url has subfolder");
  equal(Nilavu.getURL("/users/neil"), "/forum/users/neil", "relative url has subfolder");
});
