import NilavuURL from 'nilavu/lib/url';
import showModal from 'nilavu/lib/show-modal';
export default Nilavu.Route.extend({

  actions: {
    bucketCreate() {
      showModal('storageBucket', { title: 'bucket.title' });
    },
  },

  renderTemplate() {
    alert("***************************");
    this.render('navigation/default', {
     outlet: 'navigation-bar'
    });

    this.render('storages/show', {
      controller: 'storages',
      outlet: 'list-container'
    });
}
});
