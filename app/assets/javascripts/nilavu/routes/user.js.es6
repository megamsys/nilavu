const INDEX_STREAM_ROUTES = ["user.deletedPosts", "user.flaggedPosts", "userActivity.index"];

export default Nilavu.Route.extend({

    titleToken() {

        const model = this.modelFor('user');
        const email = model.get('email');
        if (email) {
            return [I18n.t("user.profile"), email];
        }
    },

    actions: {
        willTransition(transition) {
            // will reset the indexStream when transitioning to routes that aren't "indexStream"
            // otherwise the "header" will jump
            const isIndexStream = INDEX_STREAM_ROUTES.indexOf(transition.targetName) !== -1;
            this.controllerFor('user').set('indexStream', isIndexStream);
            return true;
        }
    },

    beforeModel() {
        if (this.siteSettings.hide_user_profiles_from_public && !this.currentUser) {
            this.replaceWith("discovery");
        }
    },

    model(params) {

        // If we're viewing the currently logged in user, return that object instead
        const currentUser = this.currentUser;
        if (currentUser && (params.email.toLowerCase() === currentUser.get('email'))) {

            return currentUser;

        }

        return Nilavu.User.create({
            username: params.username
        });
    },

    afterModel() {

        const user = this.modelFor('user');

        const self = this;
        return user.findDetails();
        /*.then(function() {
            alert("findStaffInfo"+JSON.stringify(user.findStaffInfo()));
        }).catch(function() {
            return self.replaceWith('/404');
        });*/
    },

    serialize(model) {
        if (!model) return {};
        return {
            email: (Em.get(model, 'email') || '').toLowerCase()
        };
    },

    setupController(controller, user) {
        controller.set('model', user);
        this.searchService.set('searchContext', user.get('searchContext'));
    },

    /*  activate() {
          this._super();
          const user = this.modelFor('user');
          this.messageBus.subscribe("/users/" + user.get('email_lower'), function(data) {
              user.loadUserAction(data);
          });
      },*/

    deactivate() {
        this._super();
        this.messageBus.unsubscribe("/users/" + this.modelFor('user').get('email_lower'));

        // Remove the search context
        this.searchService.set('searchContext', null);
    }

});
