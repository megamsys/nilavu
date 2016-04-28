import { on, observes } from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({
  classNames: ['combobox'],
  valueAttribute: 'id',
  nameProperty: 'name',
  launchableName: ' ',

  showLaunchableImage: '',

  @observes('value')
  valueChanged() {
    const $combo = this.$(),
          val = this.get('value');

    if (val !== undefined && val !== null) {
      $combo.select2('val', val.toString());
    } else {
      $combo.select2('val', null);
    }
  },

  @on('didInsertElement')
  _initializeCombo() {

  },

  @on('willDestroyElement')
  _destroyDropdown() {
    this.$().select2('destroy');
  }

});
