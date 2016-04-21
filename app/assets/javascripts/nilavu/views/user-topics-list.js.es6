import LoadMore from "nilavu/mixins/load-more";

export default Ember.View.extend(LoadMore, {
  classNames: ['paginated-topics-list'],
  eyelineSelector: '.paginated-topics-list .topic-list tr',
});
