import {  on, observes, computed } from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({
    classNameBindings: ['isActive:active'],

    flavorName: Em.computed.alias('flavor.name'),

    fullFavor: Em.computed.alias('flavor.value'),

    favorSplitter: function() {
      const ffavor = this.get('fullFavor');
      if(!Ember.isEmpty(ffavor)) {
          return ffavor.split(',')
      }
      return [];
    }.property('fullFavor'),

    _splitAt: function(idx) {
      const splitFavor = this.get('favorSplitter');
      return splitFavor.length  > 0  ? splitFavor[idx] : "";
    },


    cpu: function() {
        return this._splitAt(0);
    }.property(),

    memory: function() {
        return this._splitAt(1);
    }.property(),

    storage: function() {
        return this._splitAt(2);
    }.property(),


    isActive: function() {
      const resource = this.get('resourceSelected') || "";
        return resource.trim().length > 0 && resource.trim() == this.get('resourceName');
    }.property("resourceSelected"),


    myStyle: Ember.computed('display', function() {
        return Ember.String.htmlSafe("display:none");
    }),

    actions: {
        showBill: function() {
            //    alert("selected " + this.get('resourceSelected'));
        }
    }

});
