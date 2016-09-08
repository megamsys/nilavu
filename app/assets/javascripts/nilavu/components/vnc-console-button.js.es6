import {
    on,
    observes
} from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({

  buttonDisabled: function() {
    return !this.get('activateVNC');

  }.property('activateVNC'),

actions:
{
    showVNC() {
      const self = this;
      const promise = this.get('model').reload().then(function(result) {
        const host = self.get('model').filterOutputs("vnchost"),
            port = self.get('model').filterOutputs("vncport");

        if (host == undefined || host == "" || port == "" || port == undefined) {
            // this.notificationMessages.error(I18n.t('vm_management.vnc_host_port_empty'));
        } else {
            showModal('vnc', {
                userTitle: "VNC Connected :" + this.get('title'),
                smallTitle: true,
                titleCentered: true
            }).setProperties({host: host, port: port});
        }

      }).catch(function(e) {
        // this.notificationMessages.error(I18n.t('vm_management.vnc_host_port_empty'));

      });
    },
},

});
