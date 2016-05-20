import registerUnbound from 'nilavu/helpers/register-unbound';

/**
  Display logic for currency. It is unbound in Ember but will use jQuery to
  update.
**/
registerUnbound('format-currency', function(val, params) {
  let currency = Ember.isEmpty(params.currency) ? Nilavu.SiteSetting.currency : params.currency;

  if (val) {
    return new Handlebars.SafeString(currency + val);
  }
});
