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
    model(params) {

      alert(JSON.stringify(params));
      return params;
    },
    beforeModel() {
        var self = this;
        return self.getKey().then(function(result) {
            this.set('model',this.get(result));
            alert(JSON.stringify(model));
        }, function(e) {
            return self.notificationMessages.error(I18n.t("ssh_keys.download_error"));
        });

    },
    getKey() {
        return Nilavu.ajax("/ssh_key/list", {
            type: 'GET'
        });
    },
    renderTemplate() {
        this.render('navigation/default', {
            outlet: 'navigation-bar'
        });

        this.render('sshkey/show', {
            controller: 'sshkey-show',
            outlet: 'list-container'
        });
    }

});
