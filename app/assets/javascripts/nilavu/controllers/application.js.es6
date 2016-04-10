import computed from 'ember-addons/ember-computed-decorators';

export default Ember.Controller.extend({
  showTop: true,
  showFooter: false,
  styleCategory: null,

  @computed
  canSignUp() {
    return !Nilavu.SiteSettings.invite_only &&
           Nilavu.SiteSettings.allow_new_registrations &&
           !Nilavu.SiteSettings.enable_sso;
  },

  @computed
  loginRequired() {
    //return Nilavu.SiteSettings.login_required && !Nilavu.User.current();
    console.log(">  application.controller loginRequired="+!Nilavu.User.current());
    return !Nilavu.User.current();
  },
});
