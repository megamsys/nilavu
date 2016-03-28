import Permalink from 'admin/models/permalink';

export default Nilavu.Route.extend({
  model() {
    return Permalink.findAll();
  },

  setupController(controller, model) {
    controller.set('model', model);
  }
});
