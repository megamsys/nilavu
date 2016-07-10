import { reposForUser, repoProviderDescription } from 'nilavu/lib/github';

//hmmm (:=)this is written with a mixed idea of supporting multi sources.
export default Ember.Component.extend({
    elementId: 'repo-github',
    classNameBindings: ['hidden'],
    hidden: Em.computed.equal('buttons.length', 0),
    cachedReposNone: Em.computed.equal('category.repos.length', 0),

    repoDetail: null,

    _preloadIfToken: function() {
        const session = Nilavu.Session.currentProp('external_auth_githubresult');
    }.on('init'),

    repos: function() {
        let result = [];
        if (!this.get('cachedReposNone')) {
            this.set('resultRepos', this.get('category.repos'));
        }
        if (this.get('resultRepos') && this.get('resultRepos').length > 0) {
            this.get('resultRepos').forEach(function(repo) {
                result.push({
                    name: repo.clone_url,
                    value: repo.clone_url
                })
            });
        }
        return result;
    }.property('resultRepos'),

    loading: false,

    showSpinner: function() {
        return this.get('loading');
    }.property('loading'),

    refreshRepo: function() {
        this.set('loading', true);
        
        //sleep for sometime.
        const self = this;
        this._repos = reposForUser();

        if (!this._repos) { this.notificationMessages.error(I18n.t('customapp.github_error')); return; }

        this._repos.then((content) => {
            this.set('category.repos', content);
            self.setProperties({ noResults: !content, resultRepos: content });
        }).finally(() => {
            self.set('loading', false);
            self._repos = null;
        });

        this.notificationMessages.success(I18n.t('customapp.github_description'));
    }.observes('sourceAuthenticated'),

    selectedRepoChanged: function() {
        if (this.get('selectedRepo')) {
            this.set('repoDetail', this.repoDetails(this.get('selectedRepo')));
            this.set('category.repoDetail', this.get('repoDetail'));
        }
    }.observes('selectedRepo'),

    repoDetails: function(repo) {
        let repoDetail = {};

        if (this.get('resultRepos') && this.get('resultRepos').length > 0) {
            const rt = this.get('resultRepos').resultTypes.filter(f => f.clone_url == repo);
            if (rt && rt.length > 0) {
                repoDetail = rt.get('firstObject');
            }
        }

        return repoDetail;
    },

});
