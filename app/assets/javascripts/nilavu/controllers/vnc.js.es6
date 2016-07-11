import ModalFunctionality from 'nilavu/mixins/modal-functionality';
// Modal for editing / creating a category
export default Ember.Controller.extend(ModalFunctionality, {
    title: function() {
        return "VNC viewer  " + this.get('host');
    }.property('host', 'port')

});
