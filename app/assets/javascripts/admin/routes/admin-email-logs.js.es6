import EmailLog from 'admin/models/email-log';

export default Nilavu.Route.extend({

  model() {
    return EmailLog.findAll({ status: this.get("status") });
  },

  setupController(controller, model) {
    controller.set("model", model);
    controller.set("filter", { status: this.get("status") });
  }

});
