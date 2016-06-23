import showModal from 'nilavu/lib/show-modal';

export default Nilavu.Route.extend({

  actions: {
      upload() {
          showModal('fileUpload', {
              title: 'bucket.file',
              smallTitle: true,
              titleCentered: false
          });
      }
},
renderTemplate() {
    this.render('navigation/default', {
        outlet: 'navigation-bar'
    });

    this.render('storages/files', {
        controller: 'storages-files',
        outlet: 'list-container'
    });
}
});
