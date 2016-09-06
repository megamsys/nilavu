import NilavuURL from 'nilavu/lib/url';
export default Nilavu.Route.extend({

    redirect() {
        return this.redirectIfLoginRequired();
    },

    setupParams(show, params) {
        return show;
    },

    model(params) {
        const self = this;      
        var ssh = this.store.createRecord('ssh');
        return ssh.reload().then(function(result) {
            self.set('loading', false);
            return self.setupParams(ssh, params);
        }).catch(function(e) {
            self.set('loading', false);
        });
    },

    setupController(controller, model) {
        const sshController = this.controllerFor('sshkeys-show');
        sshController.setProperties({
            model
        });
    },

    renderTemplate() {
        this.render('navigation/default', {
            outlet: 'navigation-bar'
        });

        this.render('sshkeys/show', {
            controller: 'sshkeys-show',
            outlet: 'list-container'
        });
    },
    actions: {
      didTransition() {
        this.controllerFor("application").set("showFooter", true);
        return true;
      }
    }

});
