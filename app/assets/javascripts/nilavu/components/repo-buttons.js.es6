export default Ember.Component.extend({
    elementId: 'repo-buttons',
    classNameBindings: ['hidden'],

    hidden: Em.computed.equal('buttons.length', 0),

    buttons: function() {
        return Em.get('Nilavu.RepoMethod.all');
    }.property(),


    showSpinner: function() {
        return this.get('authenticate');
    }.property('authenticate'),

    actions: {
        //should be moved to a service
        externalLogin: function(loginMethod) {
            const name = loginMethod.get("name");
            var authUrl = Nilavu.getURL("/auth/" + name);
            if (loginMethod.get("fullScreenLogin")) {
                window.location = authUrl;
            } else {
                this.set('authenticate', name);
                const left = this.get('lastX') - 400;
                const top = this.get('lastY') - 200;

                const height = loginMethod.get("frameHeight") || 400;
                const width = loginMethod.get("frameWidth") || 800;
                const w = window.open(authUrl, "_blank",
                    "menubar=no,status=no,height=" + height + ",width=" + width + ",left=" + left + ",top=" + top);
                const self = this;
                const timer = setInterval(function() {
                    if (!w || w.closed) {
                        clearInterval(timer);
                        self.notificationMessages.success(I18n.t('customapp.repo_authcomplete'));
                        self.set('sourceAuthenticated', self.get('authenticate'));
                        self.set('authenticate', null);
                    }
                }, 1000);
            }
        }
    }

});
