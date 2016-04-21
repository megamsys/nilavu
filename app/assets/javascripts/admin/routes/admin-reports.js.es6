/**
  Handles routes for admin reports

  @class AdminReportsRoute
  @extends Nilavu.Route
  @namespace Nilavu
  @module Nilavu
**/
export default Nilavu.Route.extend({
  model: function(params) {
    const Report = require('admin/models/report').default;
    return Report.find(params.type);
  },

  setupController: function(controller, model) {
    controller.setProperties({
      model: model,
      categoryId: 'all',
      startDate: moment(model.get('start_date')).format('YYYY-MM-DD'),
      endDate: moment(model.get('end_date')).format('YYYY-MM-DD')
    });
  }
});
