import buildCategoryRoute from 'nilavu/routes/build-category-route';
import buildTopicRoute from 'nilavu/routes/build-topic-route';
import DiscoverySortableController from 'nilavu/controllers/discovery-sortable';

export default {
  after: 'inject-discourse-objects',
  name: 'dynamic-route-builders',

  initialize(container, app) {
    console.log("--- Dynamic Route builder initializing");
    app.DiscoveryCategoryController = DiscoverySortableController.extend();
    app.DiscoveryParentCategoryController = DiscoverySortableController.extend();
    app.DiscoveryCategoryNoneController = DiscoverySortableController.extend();
    app.DiscoveryCategoryWithIDController = DiscoverySortableController.extend();

    app.DiscoveryCategoryRoute = buildCategoryRoute('latest');
    app.DiscoveryParentCategoryRoute = buildCategoryRoute('latest');
    app.DiscoveryCategoryNoneRoute = buildCategoryRoute('latest', {no_subcategories: true});

    const site = Nilavu.Site.current();
    site.get('filters').forEach(filter => {
      const filterCapitalized = filter.capitalize();
      app[`Discovery${filterCapitalized}Controller`] = DiscoverySortableController.extend();
      app[`Discovery${filterCapitalized}CategoryController`] = DiscoverySortableController.extend();
      app[`Discovery${filterCapitalized}ParentCategoryController`] = DiscoverySortableController.extend();
      app[`Discovery${filterCapitalized}CategoryNoneController`] = DiscoverySortableController.extend();
      app[`Discovery${filterCapitalized}Route`] = buildTopicRoute(filter);
      app[`Discovery${filterCapitalized}CategoryRoute`] = buildCategoryRoute(filter);
      app[`Discovery${filterCapitalized}ParentCategoryRoute`] = buildCategoryRoute(filter);
      app[`Discovery${filterCapitalized}CategoryNoneRoute`] = buildCategoryRoute(filter, {no_subcategories: true});
    });

    Nilavu.DiscoveryTopController = DiscoverySortableController.extend();
    Nilavu.DiscoveryTopCategoryController = DiscoverySortableController.extend();
    Nilavu.DiscoveryTopParentCategoryController = DiscoverySortableController.extend();
    Nilavu.DiscoveryTopCategoryNoneController = DiscoverySortableController.extend();

    Nilavu.DiscoveryTopRoute = buildTopicRoute('top', {
      actions: {
        willTransition() {
          Nilavu.User.currentProp("should_be_redirected_to_top", false);
          Nilavu.User.currentProp("redirected_to_top.reason", null);
          return this._super();
        }
      }
    });
    Nilavu.DiscoveryTopCategoryRoute = buildCategoryRoute('top');
    Nilavu.DiscoveryTopParentCategoryRoute = buildCategoryRoute('top');
    Nilavu.DiscoveryTopCategoryNoneRoute = buildCategoryRoute('top', {no_subcategories: true});

    site.get('periods').forEach(period => {
      const periodCapitalized = period.capitalize();
      app[`DiscoveryTop${periodCapitalized}Controller`] = DiscoverySortableController.extend();
      app[`DiscoveryTop${periodCapitalized}CategoryController`] = DiscoverySortableController.extend();
      app[`DiscoveryTop${periodCapitalized}ParentCategoryController`] = DiscoverySortableController.extend();
      app[`DiscoveryTop${periodCapitalized}CategoryNoneController`] = DiscoverySortableController.extend();
      app[`DiscoveryTop${periodCapitalized}Route`] = buildTopicRoute('top/' + period);
      app[`DiscoveryTop${periodCapitalized}CategoryRoute`] = buildCategoryRoute('top/' + period);
      app[`DiscoveryTop${periodCapitalized}ParentCategoryRoute`] = buildCategoryRoute('top/' + period);
      app[`DiscoveryTop${periodCapitalized}CategoryNoneRoute`] = buildCategoryRoute('top/' + period, {no_subcategories: true});
    });
  }
};
