import buildTopicRoute from 'nilavu/routes/build-topic-route';
import DiscoverySortableController from 'nilavu/controllers/discovery-sortable';

export default {
  after: 'inject-discourse-objects',
  name: 'dynamic-route-builders',

  initialize(container, app) {
    console.log("> dynamic_route_builder initializing");

    const site = Nilavu.Site.current();
    site.get('filters').forEach(filter => {
      const filterCapitalized = filter.capitalize();
      app[`Discovery${filterCapitalized}Controller`] = DiscoverySortableController.extend();
      app[`Discovery${filterCapitalized}Route`] = buildTopicRoute(filter);
    });

    Nilavu.DiscoveryTopController = DiscoverySortableController.extend();

    Nilavu.DiscoveryTopRoute = buildTopicRoute('top', {
      actions: {
        willTransition() {
          Nilavu.User.currentProp("should_be_redirected_to_top", false);
          Nilavu.User.currentProp("redirected_to_top.reason", null);
          return this._super();
        }
      }
    });
  }
};
