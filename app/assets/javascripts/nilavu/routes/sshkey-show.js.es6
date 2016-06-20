import NilavuURL from 'nilavu/lib/url';
import showModal from 'nilavu/lib/show-modal';
export default Nilavu.Route.extend({
actions: {
  sshCreate() {
    showModal('sshkeyCreate', { title: 'ssh_keys.create' });
  },
},

  renderTemplate() {
    this.render('navigation/default', {
     outlet: 'navigation-bar'
    });

    this.render('sshkey/show', {
      controller: 'sshkey',
      outlet: 'list-container'
    });
  }

});
