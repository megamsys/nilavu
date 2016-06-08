import {
    observes
} from 'ember-addons/ember-computed-decorators';
import SSHOptionType from 'nilavu/models/sshoption-type';

export default Ember.Component.extend({

    launchKeyPair: '',

    selectedSSHOption: function() {
       if (this.oldPairs) {
         return SSHOptionType.OLD;
       }
       return  SSHOptionType.CREATE;
    }.property(),

    sshOptionChanged: function() {
        this.set('category.keypairoption', this.get('selectedSSHOption'));
        if (this.get('showOldPairs')) {
          this.set('category.keypairnameoption', this.get('selectedKeyPairOption'));
        } else {
            this.set('category.keypairnameoption', this.get('launchKeyPair'));
        }
    },

    showOldPairs: function() {
        if (this.selectedSSHOption == SSHOptionType.OLD) return true;

        return false;
    }.property('category.summarizing.sshs', 'category.keypairoption'),

    oldPairs: function() {
        return this.get('category.summarizing.sshs')
    }.property('category.summarizing.sshs'),

    oldPairFrequencies: function() {
        var rval = [];
        _.each(this.get("oldPairs"), function(p) {
            rval.addObject({ name: p, value: p });
        });
        return rval;
    }.property("oldPairs"),

    selectedKeyPairOption: function() {
        return this.get('oldPairFrequencies.firstObject');
    }.property('oldPairFrequencies'),

    change: function() {
        Ember.run.once(this, 'sshOptionChanged');
    }

});
