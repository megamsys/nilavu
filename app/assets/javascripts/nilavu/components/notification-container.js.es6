export default Ember.Component.extend({
  classNames: ['c-notification__container'],
  classNameBindings: [
    'computedPosition'
  ],

  computedPosition: Ember.computed('position', function() {
    if (this.get('position')) return `c-notification__container--${this.get('position')}`;

    return `c-notification__container--top`;
  })
});
