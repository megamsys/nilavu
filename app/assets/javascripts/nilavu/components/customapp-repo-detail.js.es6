import computed from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({

    withRepoDetail: function() {
        const rep = this.get('repoDetail');
        return (rep ? !Ember.isEmpty(rep) : false);
    }.property('repoDetail'),

    publicOrPrivate: function() {
        if (this.get('repoDetail.private')) {
            return I18n.t('customapp.repo_is_private');
        }
        return I18n.t('customapp.repo_is_public');
    }.property('repoDetail'),

    language: Ember.computed.alias('repoDetail.language'),

    defaultBranch: Ember.computed.alias('repoDetail.default_branch'),

    updatedAt: Ember.computed.alias('repoDetail.updated_at'),

    description: Ember.computed.alias('repoDetail.description')
});
