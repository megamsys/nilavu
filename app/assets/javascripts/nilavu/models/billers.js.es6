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
import NilavuURL from 'nilavu/lib/url';

const Billers = RestModel.extend({


    // Update our attributes from a JSON result
    updateFromJson(json) {
        const self = this;
        self.set('subscriptions', json);

        const keys = Object.keys(json);

        keys.forEach(key => {
            self.set(key, json[key])
        });
    },

    reload() {
        const self = this;
        return Nilavu.ajax('/billers/bill/activation', {
            type: 'GET'
        }).then(function(subs_json) {
          console.log(JSON.stringify(subs_json));
            self.updateFromJson(subs_json);
        });
    },

  });

export default Billers;
