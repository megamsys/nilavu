import NilavuURL from 'nilavu/lib/url';
import {
    default as computed,
    observes
} from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({

  /*  repoChanged: function() {
        this.set('category.repotype', this.get('customRepoType')); //github
        this.set('category.selectedrepo', this.get('selectedRepo')); //git url
        this.set('category.versionoption', this.get('category.customappversion'));
        this.set('category.versiondetail', this.get('category.appDetails'));
    }.observes('selectedRepo'),
  */
    myRepos: 'Your Repos', // load it from i18n, make it a type ENUM
    publicRepos: 'Public Repo', // load it from i18n, make it a type ENUM

    myGithub: function() {
        const g = (this.get('customRepoType') == this.myRepos);
        this.set('gitty', g);
    }.observes('customRepoType'),

    myPublicRepo: function() {
        const p = (this.get('customRepoType') == this.publicRepos);
        this.set('pubty', p);
    }.observes('customRepoType')


});
