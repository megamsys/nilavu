import registerUnbound from 'nilavu/helpers/register-unbound';

// see: https://github.com/emberjs/ember.js/issues/12634
var missingViews = {};

function renderRaw(ctx, template, templateName, params) {
  params.parent = params.parent || ctx;

  if (!params.view && !missingViews[templateName]) {
    var viewClass = Nilavu.__container__.lookupFactory('view:' + templateName);
    if (viewClass) {
      params.view = viewClass.create(params);
    } else {
      missingViews[templateName] = true;
    }
  }

  return new Handlebars.SafeString(template(params));
}

registerUnbound('raw', function(templateName, params) {
  var template = Nilavu.__container__.lookup('template:' + templateName + '.raw');
  if (!template) {
    Ember.warn('Could not find raw template: ' + templateName);
    return;
  }
  return renderRaw(this, template, templateName, params);
});
