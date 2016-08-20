import registerUnbound from 'nilavu/helpers/register-unbound';

registerUnbound('topic-app-link', function(topic) {
  var title = topic.get('fancyTitle');
  var url = topic.appurl();
  var string = "<a href='" + url + "' class='title'>" + topic.name + "</a>";
  return new Handlebars.SafeString(string);
});
