import { flushMap } from 'nilavu/models/store';
import RestModel from 'nilavu/models/rest';
import { propertyEqual } from 'nilavu/lib/computed';
import { longDate } from 'nilavu/lib/formatter';
import computed from 'ember-addons/ember-computed-decorators';

const Billing = RestModel.extend({
  message: null,
  errorLoading: false,

  // Update our attributes from a JSON result
  updateFromJson(json) {
    const self = this;
    self.set('details', json);

    const keys = Object.keys(json);

    keys.forEach(key => {self.set(key, json[key])});
  },

  reload() {
    const self = this;
    return Nilavu.ajax('/billing.json', { type: 'GET' }).then(function(bill_json) {
      self.updateFromJson(bill_json);
    });
  }
});

Billing.reopenClass({

  create() {

    const result = this._super.apply(this, arguments);

    return result;
  },

  // Load the billing data(usage, history, regions)
  find(opts) {
    let url = Nilavu.getURL("/billings");

    const data = {};

    // Add the summary of filter if we have it
    if (opts && opts.summary === true) {
      data.summary = true;
    }

    // Check the preload store. If not, load it via JSON
    return Nilavu.ajax(url + ".json", {data: data});
  }
});

export default Billing;
