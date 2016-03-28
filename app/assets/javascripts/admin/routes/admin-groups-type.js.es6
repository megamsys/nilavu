import Group from 'nilavu/models/group';

export default Nilavu.Route.extend({
  model(params) {
    this.set("type", params.type);
    return Group.findAll().then(function(groups) {
      return groups.filterBy("type", params.type);
    });
  },

  setupController(controller, model){
    controller.set("type", this.get("type"));
    controller.set("model", model);
  }
});
