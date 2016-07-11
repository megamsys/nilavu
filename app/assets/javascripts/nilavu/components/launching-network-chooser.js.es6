import {     observes  } from 'ember-addons/ember-computed-decorators';
import debounce from 'nilavu/lib/debounce';

export default Ember.Component.extend({

    enablePrivateIPv4:  Ember.computed.alias('category.privateipv4'),
    enablePublicIPv4:  Ember.computed.alias('category.publicipv4'),
    enablePrivateIPv6:  Ember.computed.alias('category.privateipv6'),
    enablePublicIPv6:  Ember.computed.alias('category.publicipv6'),

    _initDefaults: function() {
      this.set('category.privateipv4', true);
      this.set('category.publicipv4', false);
      this.set('category.privateipv6', false);
      this.set('category.publicipv6', false);
    }.on('init'),


    actions: {
      enablePrivateIPv6Flag: debounce(function(title) {
        if (Em.isEmpty(title)) {
          this.set('category.privateipv6', this.get('enablePrivateIPv6'));
          return;
        }
      }, 300),

      enablePublicIPv6Flag: debounce(function(title) {
        if (Em.isEmpty(title)) {
          this.set('category.publicipv6', this.get('enablePublicIPv6'));
          return;
        }
      }, 300),

      enablePublicIPv4Flag: debounce(function(title) {
        if (Em.isEmpty(title)) {
          this.set('category.publicipv4', this.get('enablePublicIPv4'));
          return;
        }
      }, 300),

      enablePrivateIPv4Flag: debounce(function(title) {
        if (Em.isEmpty(title)) {
          this.set('category.privateipv4', this.get('enablePrivateIPv4'));
          return;
        }
      }, 300)

    }
  });
