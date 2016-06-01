import {     observes  } from 'ember-addons/ember-computed-decorators';
import debounce from 'nilavu/lib/debounce';

export default Ember.Component.extend({

    enablePrivNetworkFlag:  Ember.computed.alias('category.privnetworkoption'),
    enableIPv6Flag:  Ember.computed.alias('category.ipv6option'),

    _initDefaults: function() {
      this.set('category.privnetworkoption', true);
      this.set('category.ipv6option', false);
    }.on('init'),


    actions: {
      enableIPv6: debounce(function(title) {
        if (Em.isEmpty(title)) {
          this.set('category.ipv6option', this.get('enableIPv6Flag'));
          return;
        }
      }, 300),


      enablePrivNetwork: debounce(function(title) {
        if (Em.isEmpty(title)) {
          this.set('category.privnetworkoption', this.get('enablePrivNetworkFlag'));
          return;
        }
      }, 300)

    }
  });
