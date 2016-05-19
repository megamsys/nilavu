export default Ember.Component.extend({
  tagName: 'input',
  type: 'radio',
  attributeBindings: [ 'checked:checked', 'name', 'type', 'value', 'style' ],

  checked: function () {
    if (this.get('value') === this.get('selection')) {
      return true;
    } else { return false; }
  },

  change: function () {
    this.set('selection', this.get('value'));
    Ember.run.once(this, 'checked'); //manual observer
  }
});
