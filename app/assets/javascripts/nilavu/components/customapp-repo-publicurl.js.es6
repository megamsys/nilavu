export default Ember.Component.extend({
    elementId: 'repo-publicurl',
    classNameBindings: ['hidden'],
    hidden: Em.computed.equal('buttons.length', 0),

    repoDetail: null,
    
    loading: false,
    
    
    _init: function(){
        this.set('category.sourceidentifier', this.constants.GIT);
    }.on('init'),

    //we can verify if the URL is correct or not ? 
    showSpinner: function() {
        return this.get('loading');
    }.property('loading'),

    selectedRepoChanged: function() {
        if (this.get('selectedRepo')) {
            this.set('category.repoDetail', {clone_url: this.get('selectedRepo')});
        }
    }.observes('selectedRepo'),
    
});
