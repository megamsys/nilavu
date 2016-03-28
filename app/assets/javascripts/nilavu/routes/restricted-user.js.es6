import NilavuRoute from 'nilavu/routes/nilavu';

// A base route that allows us to redirect when access is restricted
export default NilavuRoute.extend({

  afterModel() {
    if (!this.modelFor('user').get('can_edit')) {
      this.replaceWith('userActivity');
    }
  }

});
