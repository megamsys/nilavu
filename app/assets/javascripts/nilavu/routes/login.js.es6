import buildStaticRoute from 'nilavu/routes/build-static-route';

const LoginRoute = buildStaticRoute('login');

LoginRoute.reopen({

  beforeModel() {
    if (!this.siteSettings.login_required) {
      Ember.run.next(() => this.send('showLogin'));
    }
  }
});

export default LoginRoute;
