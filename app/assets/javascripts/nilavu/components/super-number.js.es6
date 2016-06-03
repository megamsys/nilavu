import NumberFormatter from 'nilavu/lib/super-number-formatter';

var DOWN_ARROW = 40,
    UP_ARROW = 38;

export default Ember.Component.extend({
  classNames: ["super_number"],
  value: 1,
  min: null,
  max: null,
  precision: null,
  scale: null,
  loop: false,
  step: 1,
  numberFormatter: null,
  init: function() {
    this._super();
    var options = this.getProperties('step', 'precision', 'scale', 'min', 'max', 'loop');
    this.set('numberFormatter', new NumberFormatter(this.get('value'), options));
  },
  syncFormatter: function(){
    this.set('numberFormatter', this.numberFormatter.setValue(this.get('value')));
  }.observes('value'),
  focusOut: function(){
    this.set('value', this.get('numberFormatter').toString());
  },
  keyDown: function(e) {
    if(e.which === DOWN_ARROW) {
      this.send('handleDecrement');
    } else if(e.which === UP_ARROW) {
      this.send('handleIncrement');
    }
  },
  actions: {
    handleIncrement: function(){
      this.set('value', this.get('numberFormatter').add(this.get('step')));
    },
    handleDecrement: function(){
      this.set('value', this.get('numberFormatter').subtract(this.get('step')));
    }
  }
});
