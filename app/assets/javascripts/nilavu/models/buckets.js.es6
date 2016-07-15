import { flushMap } from 'nilavu/models/store';
import RestModel from 'nilavu/models/rest';
import { propertyEqual } from 'nilavu/lib/computed';
import { longDate } from 'nilavu/lib/formatter';
import computed from 'ember-addons/ember-computed-decorators';

const Buckets = RestModel.extend({
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
    return Nilavu.ajax('/buckets.json', { type: 'GET' }).then(function(bucket_json) {
      self.updateFromJson(bucket_json);
    });
  }
});

Buckets.reopenClass({

  // Load the billing data(usage, history, regions)
  list() {
    let url = Nilavu.getURL("/buckets");
    const data = {};
    // Check the preload store. If not, load it via JSON
    return Nilavu.ajax(url + ".json", {});
  }
});

export default Buckets;
