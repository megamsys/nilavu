import ScrollTop from 'nilavu/mixins/scroll-top';
import LoadMore from "nilavu/mixins/load-more";

export default Ember.View.extend(ScrollTop, LoadMore, {
  eyelineSelector: '.group-members tr',
});
