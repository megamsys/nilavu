import Topic from 'nilavu/models/topic';
import NilavuURL from 'nilavu/lib/url';

export default Nilavu.Route.extend({
  model: function(params) {
    return Topic.idForSlug(params.slug);
  },

  afterModel: function(result) {
    NilavuURL.routeTo(result.url, { replaceURL: true });
  }
});
