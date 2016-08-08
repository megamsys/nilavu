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
    loading: false,

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

  actions: {
        onClick() {
            this.set('formSubmitted', true)
          },

        changePassword() {
          const self=this;
          self.set('loading', true);
          if (Ember.isEmpty(this.get('model.newPassword')) || Ember.isEmpty(this.get('model.retypePassword'))) {
              this.notificationMessages.error(I18n.t('user.password.blank_password'));
              return;
          }
          return this.get('model').changePassword().then(function(result){
          // password changed
          self.set('loading',false);
          self.get('model').resetField();
          self.set('formSubmitted', false);
          self.notificationMessages.success(I18n.t('user.change_password.reset'));
        }).catch(function(e) {
            self.set('loading',false);
            self.get('model').resetField();
            self.set('formSubmitted', false);
            self.notificationMessages.error(I18n.t('user.change_password.resetfail'));
        })
      },


    },

});
