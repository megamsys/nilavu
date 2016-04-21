import registerUnbound from 'nilavu/helpers/register-unbound';

registerUnbound('cook-text', function(text) {
  return new Handlebars.SafeString(Nilavu.Markdown.cook(text, {sanitize: true}));
});

