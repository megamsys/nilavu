Em.Handlebars.helper('preserve-newlines', str => {
  return new Handlebars.SafeString(Nilavu.Utilities.escapeExpression(str).replace(/\n/g, "<br>"));
});
