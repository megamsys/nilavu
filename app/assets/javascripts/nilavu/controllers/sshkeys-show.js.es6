import showModal from 'nilavu/lib/show-modal';
export default Ember.Controller.extend({
    needs: ['modal', 'sshkey-create'],
    title: "SSH Keys",

    name: function() {
        var model = this.get('model.message');
        return model;
    }.property('model'),

    actions: {
        sshCreate() {
            showModal('sshkeyCreate', {
                title: 'ssh_keys.create',
                smallTitle: true,
                titleCentered: true
            });
        },

        sshImport() {
            showModal('sshkeyImport', {
                title: 'ssh_keys.import',
                smallTitle: true,
                titleCentered: true
            });
        },
    },

});
