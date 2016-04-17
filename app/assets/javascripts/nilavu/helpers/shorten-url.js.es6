import registerUnbound from 'nilavu/helpers/register-unbound';

registerUnbound('shorten-url', function(url) {
  var matches = url.match(/\//g);

  if (matches && matches.length === 3) {
    url = url.replace(/\/$/, '');
  }
  url = url.replace(/^https?:\/\//, '');
  url = url.replace(/^www\./, '');
  return url.substring(0, 80);
});
