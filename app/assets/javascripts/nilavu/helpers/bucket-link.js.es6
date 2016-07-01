import registerUnbound from 'nilavu/helpers/register-unbound';

registerUnbound('bucket-link', function(bucket) {
  var title = "";
  var url = Nilavu.getURL("/storages/b/") + bucket.name
  var string = "<a href='" + url + "' class='title'>" + bucket.name + "</a>";
  return new Handlebars.SafeString(string);
});
