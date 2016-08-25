import { on, observes } from 'ember-addons/ember-computed-decorators';
import { propertyEqual } from 'nilavu/lib/computed';

export default Ember.Component.extend({
    tagName: 'div',
    classNameBindings: [':tab-pane', 'isActive:active'],

    snapshots: Ember.computed.alias('category.cooking.snapshots.snapshots_all'),

    versionable: null,

    launchableName: function() {
        return this.get('name').split('-').pop();
    }.property('name'),

    formatLaunchable: function() {
      if(this.get('snapshots') == null){
        return;
      }
      else{
        const out = this.get('snapshots').map(function(v) {
            return v.name;
        });
        return out;
      }
    },


    filterLaunchable: function(name) {
        const out = this.get('snapshots').filter(function(v) {
            return (v.name.toLowerCase() == name)
        });

        return out.length > 0 ? out.get('firstObject') : out;
    },

    versionChanged: function() {
        const lv = this.formatLaunchable();
        //ideally we have to pull the asm_id and get the cattype from there.
        const lf = { cattype: 'TORPEDO' , options: {key: 'oneclick',value: 'true'}};
        this.set('cookingVersions', lv);
        this.set('cookingDetail', lf);
    }.observes('category.cooking'),

    //a drab name.. cooking...
    versions: function() {
        return this.get('cookingVersions');
    }.property('cookingVersions'),

    versionDetail: function() {
        return this.get('cookingDetail');
    }.property('cookingDetail'),

    isActive: function() {
        const ln = this.get('launchableName');
        this.set('category.versionoption', "");
        this.set('category.versiondetail', "");
        return ln.trim().length > 0 && ln.trim() == this.get('selectedTab');
    }.property('selectedTab')

});
