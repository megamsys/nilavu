import { propertyEqual } from 'nilavu/lib/computed';
import debounce from 'nilavu/lib/debounce';
import {
  setting
} from 'nilavu/lib/computed';
import {
  on
} from 'ember-addons/ember-computed-decorators';

export default Em.Component.extend({
    formSubmitted: false,
    isDeveloper: false,

    submitDisabled: function() {
        if (!this.get('formSubmitted')) return true;
        return false;
    }.property('formSubmitted'),

    passwordInstructions: function() {
      return this.get('isDeveloper') ? I18n.t('user.password.instructions', {
        count: Nilavu.SiteSettings.min_admin_password_length
      }) : I18n.t('user.password.instructions', {
        count: Nilavu.SiteSettings.min_password_length
      });
    }.property('isDeveloper'),

    passwordConfirmValidation:function(){

        if (!Ember.isEmpty(this.get('model.retypePassword')) && this.get('model.newPassword') === this.get('model.retypePassword')) {
          return Nilavu.InputValidation.create({
            ok: true,
            reason: I18n.t('user.password.confirm')
          });
        }

        if (!Ember.isEmpty(this.get('model.retypePassword')) && this.get('model.newPassword') != this.get('model.retypePassword')) {
          return Nilavu.InputValidation.create({
            failed: true,
            reason: I18n.t('user.password.confirmpassword')
          });
        }

    }.property('model.retypePassword','model.newPassword'),

    passwordValidation: function() {
      const password = this.get("model.newPassword");
      // If too short
      const passwordLength = this.get('isDeveloper') ? Nilavu.SiteSettings.min_admin_password_length : Nilavu.SiteSettings.min_password_length;
      if (password.length < passwordLength) {
        return Nilavu.InputValidation.create({
          failed: true,
          reason: I18n.t('user.password.too_short')
        });
      }


      if (!Ember.isEmpty(this.get('model.email')) && this.get('model.newPassword') === this.get('model.email')) {
        return Nilavu.InputValidation.create({
          failed: true,
          reason: I18n.t('user.password.same_as_email')
        });
      }

      // Looks good!
      return Nilavu.InputValidation.create({
        ok: true,
        reason: I18n.t('user.password.ok')
      });
    }.property('model.newPassword','model.email', 'isDeveloper'),

  actions: {
        onClick() {
            this.set('formSubmitted', true)
          },

        changePassword() {
          const self=this;
          if (Ember.isEmpty(this.get('model.newPassword')) || Ember.isEmpty(this.get('model.retypePassword'))) {
              this.notificationMessages.error(I18n.t('user.password.blank_password'));
              return;
          }
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
