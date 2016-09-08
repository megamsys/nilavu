import {propertyEqual} from 'nilavu/lib/computed';

export default Em.Component.extend({
  formSubmitted: false,
  loading: false,

  submitDisabled: function() {
      // if (!this.get('formSubmitted')) return true;
      // return false;
      return true;
  }.property('formSubmitted'),

  email: function() {
        return this.get('model.email');
    }.property('model.email'),

    actions: {
        onClick() {
            this.set('formSubmitted', true)
        },

        changeUsername() {
            const self = this;
            self.set('loading', true);
            if (Ember.isEmpty(this.get('model.first_name'))) {
                this.notificationMessages.error(I18n.t('user.change_name.blank'));
                return;
            }
            return this.get('model').changeUsername().then(function(result) {
                // username changed
                self.set('loading', false);
                self.set('formSubmitted', false);
                self.notificationMessages.success(I18n.t('user.change_name.reset'));
            }).catch(function(e) {
                self.set('loading', false);
                self.set('formSubmitted', false);
                self.notificationMessages.error(I18n.t('user.change_name.resetfail'));
            })
        },

    },

});
