import NilavuURL from 'nilavu/lib/url';

export default Nilavu.Route.extend({

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
