import { propertyEqual } from 'nilavu/lib/computed';

export default Em.Component.extend({
    formSubmitted: false,

    submitDisabled: function() {
        if (!this.get('formSubmitted')) return true;
        return false;
    }.property('formSubmitted'),

  actions: {
        onClick() {
            this.set('formSubmitted', true)
          },

        changePassword() {
          const self=this;
          return this.get('model').changePassword().then(function(result){
          // password changed
          self.get('model').resetField();
          self.set('formSubmitted', false);
          self.notificationMessages.success(I18n.t('user.change_password.reset'));
        }).catch(function(e) {
            self.set('formSubmitted', false);
            self.notificationMessages.error(I18n.t('user.change_password.resetfail'));
        })
      },


    },

});
