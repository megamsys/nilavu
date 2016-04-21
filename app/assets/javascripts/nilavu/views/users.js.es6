import LoadMore from 'nilavu/mixins/load-more';

export default Ember.View.extend(LoadMore, {
  eyelineSelector: '.directory tbody tr'
});
