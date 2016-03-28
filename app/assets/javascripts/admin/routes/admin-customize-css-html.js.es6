import showModal from 'nilavu/lib/show-modal';
import { popupAjaxError } from 'nilavu/lib/ajax-error';

export default Ember.Route.extend({
  model() {
    return this.store.findAll('site-customization');
  },

  actions: {
    importModal() {
      showModal('upload-customization');
    },

    newCustomization(obj) {
      obj = obj || {name: I18n.t("admin.customize.new_style")};
      const item = this.store.createRecord('site-customization');

      const all = this.modelFor('adminCustomizeCssHtml');
      const self = this;
      item.save(obj).then(function() {
        all.pushObject(item);
        self.transitionTo('adminCustomizeCssHtml.show', item.get('id'), 'css');
      }).catch(popupAjaxError);
    }
  }
});
