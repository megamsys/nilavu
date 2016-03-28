import ModalFunctionality from 'nilavu/mixins/modal-functionality';

export default Ember.Controller.extend(ModalFunctionality, {
  needs: ['modal'],

  showGoogleSearch: function() {
    return !Nilavu.SiteSettings.login_required;
  }.property()
});
