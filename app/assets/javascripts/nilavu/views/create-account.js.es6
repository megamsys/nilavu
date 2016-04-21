export default Ember.View.extend({
  templateName: 'modal/create-account',
  title: I18n.t('create_account.title'),
  classNames: ['create-account'],


  _setup: function() {
    // Allows submitting the form when pressing 'ENTER' on *any* text input field
    // but only when the submit button is enabled.
    const createAccountController = this.get('controller');

    $('body').attr('class', 'signup_background');

    if ($.cookie('email')) {
      createAccountController.set('accountEmail', $.cookie('email'));
    }

    Em.run.schedule('afterRender', function() {
      $("input[type='text'], input[type='password']").keydown(function(e) {
        if (createAccountController.get('submitDisabled') === false && e.keyCode === 13) {
          createAccountController.send('createAccount');
        }
      });
    });
  }.on('didInsertElement')
});
