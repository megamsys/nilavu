import registerUnbound from 'nilavu/helpers/register-unbound';

registerUnbound('i18n', function(key, params) {
    return I18n.t(key, params);
});
