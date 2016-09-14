import {on, observes} from 'ember-addons/ember-computed-decorators';
import showModal from 'nilavu/lib/show-modal';
export default Ember.Component.extend({

    isEnable: function() {
        if(this.get('activateVNC')) {
          return "btn btn-success pull-right";
        } else {
          return "btn btn-default pull-right link-icons disableVNCButton";
        }
    }.property('activateVNC'),


    actions: {
        showVNC() {
            const self = this;
            const promise = this.get('model').reload().then(function(result) {
                const host = self.get('model').filterOutputs("vnchost"),
                    port = self.get('model').filterOutputs("vncport");
                if (host == undefined || host == "" || port == "" || port == undefined) {
                     self.notificationMessages.error(I18n.t('vm_management.vnc_host_port_empty'));
                } else {
                    showModal('vnc', {
                        userTitle: "VNC Connected :" + self.get('title'),
                        smallTitle: true,
                        titleCentered: true
                    }).setProperties({host: host, port: port});
                }

            }).catch(function(e) {
                 self.notificationMessages.error(I18n.t('vm_management.error'));

            });
        }
    }
});
