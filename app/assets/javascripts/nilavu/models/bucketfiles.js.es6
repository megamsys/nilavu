import {
    flushMap
} from 'nilavu/models/store';
import RestModel from 'nilavu/models/rest';
import {
    propertyEqual
} from 'nilavu/lib/computed';
import {
    longDate
} from 'nilavu/lib/formatter';
import computed from 'ember-addons/ember-computed-decorators';

const Bucketfiles = RestModel.extend({
    message: null,
    errorLoading: false,

    // Update our attributes from a JSON result
    updateFromJson(json) {
        const self = this;
        self.set('details', json);

        const keys = Object.keys(json);

        keys.forEach(key => {
            self.set(key, json[key])
        });
    },

    reload(bucket) {
        const self = this;
        return Nilavu.ajax('/b/'+bucket, {
            type: 'GET'
        }).then(function(bill_json) {
            self.updateFromJson(bill_json);
        });
    }
});

Bucketfiles.reopenClass({

    create() {

        const result = this._super.apply(this, arguments);

        return result;
    },

    // Load the billing data(usage, history, regions)
    list() {
        let url = Nilavu.getURL("/bucketfiles");

        const data = {};

        // Check the preload store. If not, load it via JSON
        return Nilavu.ajax(url + ".json", {});
    }
});

export default Bucketfiles;
