import computed from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({
  tagName: 'input',
  type: 'radio',
  attributeBindings: [ 'checked:checked', 'name', 'type', 'value', 'style' ],


    @computed("selection", "value")
    checked(selection, value) {
      return this.get('selected') === this.get('value');
    },

    sendChangedAction() {
      this.sendAction('changed', this.get('value'));
    },

    change() {
      let value = this.get('value');
      let groupValue = this.get('selection');

      if (groupValue !== value) {
        this.set('selection', value); // violates DDAU
        Ember.run.once(this, 'sendChangedAction');
      }
    }
});
