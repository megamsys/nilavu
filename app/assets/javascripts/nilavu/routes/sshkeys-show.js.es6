import NilavuURL from 'nilavu/lib/url';
import showModal from 'nilavu/lib/show-modal';
export default Nilavu.Route.extend({
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
          //  alert("4");
          //  alert(JSON.stringify(show));
          //  alert(JSON.stringify(params));


        return show;
        //  alert("4.1");
    },


    model(params) {

        const self = this;

        var ssh = this.store.createRecord('ssh');
          //  alert("1");
        return ssh.reload().then(function(result) {
           //alert(JSON.stringify(result));
                    //  alert("end");
            self.set('loading', false);
                      //  alert("end2");
                      //  alert(JSON.stringify(result.message[0].name));
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
