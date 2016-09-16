import NilavuURL from 'nilavu/lib/url';
import {  default as computed,  observes } from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({

    repoChanged: function() {
        if (!this.get('selectedRepo')) { return; }

        if (!this.get('category.customappname')) { return; }
        
        alert(this.get('selectedRepo') + " " + this.get('category.customappname'));

        this.set('category.versionoption', this.get('category.customappname'));
    }.observes('selectedRepo'),

    myRepos: I18n.t('customapp.your_repos'),

    publicRepos:I18n.t('customapp.public_repos'),

    myGithub: function() {
        const g = (this.get('customRepoType') == this.myRepos);
        this.set('gitty', g);
    }.observes('customRepoType'),

    myPublicRepo: function() {
        const p = (this.get('customRepoType') == this.publicRepos);
        this.set('pubty', p);
    }.observes('customRepoType')


});
