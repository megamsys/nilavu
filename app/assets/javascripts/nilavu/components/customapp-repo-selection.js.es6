import NilavuURL from 'nilavu/lib/url';
import {  default as computed,   observes } from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({

    gitHub:  Ember.computed.alias('gity'),

    publicRepo: Ember.computed.alias('pity'),

    myGithub: function() {
        const g = (this.get('selectedRepo') == 'Your Github Repo');
        this.set('gity',g);
    }.observes('selectedRepo'),

    myPublicRepo: function() {
        const p = (this.get('selectedRepo') == 'Public Repo');
        this.set('pity', p);
    }.observes('selectedRepo')

});
