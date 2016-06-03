export default Ember.Component.extend({
  classNameBindings: ['containerClass', 'condition:visible'],

  containerClass: function() {
    return this.get('size') ? this.get('size') : 'small';
  }.property('size'),

  render: function(buffer) {

    if (this.get('condition')) {
      buffer.push('<div class="spin ' + this.get('size') + '"}}></div>');
    } else {
      return this._super(buffer);
    }
  },

  _conditionChanged: function() {
    this.rerender();
  }.observes('condition')
});
