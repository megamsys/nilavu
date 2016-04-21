import { loadTopicView } from 'nilavu/models/topic';

export default Nilavu.Route.extend({
  model(params) {
    const topic = this.store.createRecord("topic", { id: params.id });
    return loadTopicView(topic).then(() => topic);
  },

  afterModel(topic) {
    topic.set("details.notificationReasonText", null);
  },

  actions: {
    didTransition() {
      this.controllerFor("application").set("showFooter", true);
      return true;
    }
  }
});
