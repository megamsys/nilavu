import {
    on,
    observes
} from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({
    classNameBindings: ['isActive:active'],

    fname: Ember.computed.alias('name'),

    flavors: function(){
      var  flavorArray = [];
      const flav = this.get('resource.flavors');

      for(var key in flav) {
        if(flav.hasOwnProperty(key) && key !== "toString"){
          flavorArray.push({key: key, value: flav[key]});
        }
      }
      return flavorArray;
    }.property('resource.flavors'),

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
