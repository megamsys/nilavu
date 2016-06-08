import registerUnbound from 'nilavu/helpers/register-unbound';

registerUnbound('topic-link', function(topic) {
  var title = topic.get('fancyTitle');
  var url = topic.url;

  var string = "<a href='" + url + "' class='title'>" + topic.name + "</a>";
  return new Handlebars.SafeString(string);
});
