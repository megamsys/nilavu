import { on, observes } from 'ember-addons/ember-computed-decorators';
import highlightSyntax from 'nilavu/lib/highlight-syntax';

export default Ember.Component.extend({

  @on('didInsertElement')
  @observes('code')
  _refresh: function() {
    highlightSyntax(this.$());
  }

});
