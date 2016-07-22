import buildStaticRoute from 'nilavu/routes/build-static-route';

const SignupRoute = buildStaticRoute('signup');

SignupRoute.reopen({
  beforeModel() {
    alert("hey");
    var canSignUp = this.controllerFor("application").get('canSignUp');
    alert(this.siteSettings.login_required);
    if (!this.siteSettings.login_required) {
      alert("hellow there");
      this.replaceWith('discovery.dashboard').then(e => {
        if (canSignUp) {
          Ember.run.next(() => e.send('showCreateAccount'));
        }
      });
    } else {
      alert("howdy 1");
        this.replaceWith('login').then(e => {
        if (canSignUp) {
          Ember.run.next(() => e.send('showCreateAccount'));
        }
      });
    }
  }
});

export default SignupRoute;
