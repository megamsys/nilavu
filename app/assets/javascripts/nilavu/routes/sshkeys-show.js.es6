import NilavuURL from 'nilavu/lib/url';
import showModal from 'nilavu/lib/show-modal';
export default Nilavu.Route.extend({

    redirect() {
        return this.redirectIfLoginRequired(); },


    actions: {
        sshCreate() {
            showModal('sshkeyShow', {
                title: 'ssh_keys.create',
                smallTitle: true,
                titleCentered: true
            });
        },
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
    }



});
