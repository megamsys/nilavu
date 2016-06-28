import ModalFunctionality from 'nilavu/mixins/modal-functionality';

export default Ember.Controller.extend(ModalFunctionality, {

  // You need a value in the field to submit it.
  submitDisabled: function() {
    return Ember.isEmpty((this.get('accountEmailOrUsername') || '').trim()) || this.get('disabled');
  }.property('accountEmailOrUsername', 'disabled'),

  onShow: function() {
      this.set('controllers.modal.modalClass', 'password-modal');
    if ($.cookie('email')) {
      this.set('accountEmailOrUsername', $.cookie('email'));
    }
  },

  actions: {
    submit: function() {
      var self = this;

      if (this.get('submitDisabled')) return false;

      this.set('disabled', true);

      var success = function(data) {
        // don't tell people what happened, this keeps it more secure (ensure same on server)
        var escaped = Nilavu.Utilities.escapeExpression(self.get('accountEmailOrUsername'));
        var isEmail = self.get('accountEmailOrUsername').match(/@/);
        var key = 'forgot_password.complete_' + (isEmail ? 'email' : 'username');
        var extraClass;
        if (data.success == "OK") {
           key += '_found';
          self.set('accountEmailOrUsername', '');
          self.notificationMessages.success(I18n.t(key, {email: escaped, username: escaped}),{clearDuration: 4000});
          self.send("closeModal");
        } else {
          if (data.user_found === false) {
            key += '_not_found';
            extraClass = 'error';
          }
          self.notificationMessages.success(I18n.t(key, {email: escaped, username: escaped}), extraClass);

        }
      };

      var fail = function(e) {
        self.flash(e.responseJSON.errors[0], 'error');
      };

      Nilavu.ajax('/session/forgot_password', {
        data: { login: this.get('accountEmailOrUsername').trim() },
        type: 'POST'
      }).then(success, fail).finally(function(){
        setTimeout(function(){
          self.set('disabled',false);
        }, 1000);
      });

      return false;
    }
  }

});
