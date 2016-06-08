export default function() {

    //Fake route
    this.route('dummy');
    // Error page
    this.route('exception', {
        path: '/exception'
    });

    this.resource('about', {
        path: '/about'
    });

    this.route('billing', {
        path: '/billing'
    });

    this.route('marketplaces', {
        path: '/marketplaces'
    });

    this.route('storages', {
        path: '/storages'
    });

    // Topic routes
    this.resource('topic', { path: '/t/:id' }, function() {
      this.route('fromParams', { path: '/' });
      this.route('fromParamsNear', { path: '/:nearPost' });
    });

    this.resource('discovery', {  path: '/' }, function() {
        // top
        this.route('top');

        // homepage
        this.route(Nilavu.Utilities.defaultHomepage(), {
            path: '/'
        });

        // filters
        Nilavu.Site.currentProp('filters').forEach(filter => {
          this.route(filter, { path: '/' + filter });
        });

    });


    // User routes
    this.resource('users');
    this.resource('user', {
        path: '/users/:username'
    }, function() {
        this.route('summary');
        this.resource('userActivity', {
            path: '/activity'
        }, function() {
            this.route('topics');
            this.route('replies');
            this.route('likesGiven', {
                path: 'likes-given'
            });
            this.route('bookmarks');
            this.route('pending');
        });

        this.resource('userNotifications', {
            path: '/notifications'
        }, function() {
            this.route('responses');
            this.route('likesReceived', {
                path: 'likes-received'
            });
            this.route('mentions');
            this.route('edits');
        });

        this.resource('userPrivateMessages', {
            path: '/messages'
        }, function() {
            this.route('sent');
            this.route('archive');
            this.route('group', {
                path: 'group/:name'
            });
            this.route('groupArchive', {
                path: 'group/:name/archive'
            });
        });

        this.resource('preferences', function() {
            this.route('username');
            this.route('email');
        });

    });
    this.route('signup', {
        path: '/signup'
    });

    this.route('login', {
        path: '/login'
    });

    this.route('login-preferences');
    this.route('forgot-password', {
        path: '/password-reset'
    });

}
