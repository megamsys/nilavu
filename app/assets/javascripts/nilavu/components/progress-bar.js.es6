import Ember from 'ember';
import TypeClass from 'nilavu/mixins/type-class';

const { computed } = Ember;


//Component to display a Bootstrap progress bar, see http://getbootstrap.com/components/#progress.
 export default Ember.Component.extend(TypeClass, {
  classNames: ['progress-bar'],
  classNameBindings: ['progressBarStriped', 'active'],

  attributeBindings: ['style', 'ariaValuenow', 'ariaValuemin', 'ariaValuemax'],

  classTypePrefix: 'progress-bar',


  // The lower limit of the value range
  minValue: 0,


   // The upper limit of the value range
  maxValue: 100,


  //The value the progress bar should represent
  value: 0,


  // If true a label will be shown inside the progress bar.
 showLabel: false,


  // Create a striped effect, see http://getbootstrap.com/components/#progress-striped
  striped: false,


   // Animate the stripes, see http://getbootstrap.com/components/#progress-animated
  animate: false,


   // Specify to how many digits the progress bar label should be rounded.
  roundDigits: 0,

  progressBarStriped: computed.alias('striped'),
  active: computed.alias('animate'),

  barHeadHighlight: computed('barHead', function() {
    let b = this.get('barHead');
    return 'predeploybar-title-' + b;
  }),

  ariaValuenow: computed.alias('value'),
  ariaValuemin: computed.alias('minValue'),
  ariaValuemax: computed.alias('maxValue'),


   // The percentage of `value`
  percent: computed('value', 'minValue', 'maxValue', function() {
    let value = parseFloat(this.get('value'));
    let minValue = parseFloat(this.get('minValue'));
    let maxValue = parseFloat(this.get('maxValue'));
    return Math.min(Math.max((value - minValue) / (maxValue - minValue), 0), 1) * 100;
  }),

  // The percentage of `value`, rounded to `roundDigits` digits
  percentRounded: computed('percent', 'roundDigits', function() {
    let roundFactor = Math.pow(10, this.get('roundDigits'));
    return Math.round(this.get('percent') * roundFactor) / roundFactor;
  }),

  style: computed('percent', function() {
    let percent = this.get('percent');
    let flagDeployingError = '';
    if (this.get("deployError")) {
       flagDeployingError = 'background: #e5570c;';
       percent = 100;
    }
    return new Ember.Handlebars.SafeString(`width: ${percent}%;`+flagDeployingError);
  })

});
