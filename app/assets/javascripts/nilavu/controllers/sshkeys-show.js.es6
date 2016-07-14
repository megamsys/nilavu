import showModal from 'nilavu/lib/show-modal';
export default Ember.Controller.extend({
    needs: ['modal', 'sshkey-create'],
    title: "SSH Keys",

    sortedSshKeys: Ember.computed.sort('sshkeys', 'sortDefinition'),
    sortBy: 'created_at', // default sort by date
    reverseSort: true, // default sort in descending order
    sortDefinition: Ember.computed('sortBy', 'reverseSort', function() {
        let sortOrder = this.get('reverseSort') ? 'desc' : 'asc';
        return [`${this.get('sortBy')}:${sortOrder}`];
    }),

    sshkeys: function() {
        var model = this.get('model.message');
        return model;
    }.property('model'),

    actions: {
        sshCreate() {
            showModal('sshkeyCreate', {
                title: 'ssh_keys.create',
                smallTitle: true,
                titleCentered: true,
                //model: self.modelFor('ssh')
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
