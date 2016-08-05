import computed from 'ember-addons/ember-computed-decorators';

export default Ember.Controller.extend({
  
    showTop: function() {
        return !this.get('loginRequired');
    }.property(),

    showFooter: function() {
        return !this.loginRequired;
    }.property(),

    styleCategory: null,

    @computed canSignUp() {
        return !Nilavu.SiteSettings.invite_only && Nilavu.SiteSettings.allow_new_registrations && !Nilavu.SiteSettings.enable_sso;
    },

    @computed loginRequired() {
        return !Nilavu.User.current();
    }
});
