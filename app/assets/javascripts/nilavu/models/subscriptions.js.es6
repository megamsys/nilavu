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

const Subscriptions = RestModel.extend({
    message: null,
    errorLoading: false,

    url: function() {
        let slug = this.get('slug') || '';
        if (slug.trim().length === 0) {
            slug = "topic";
        }
        return Nilavu.getURL("/t/") + (this.get('id'));
    },

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
            self.updateFromJson(subs_json);
        });
    },

    check() {
        const self = this;
        return Nilavu.ajax('/subscriptions/activation/check', {
            type: 'GET'
        }).then(function(subs_json) {
            self.updateFromJson(subs_json);
        });
    }
});

Subscriptions.reopenClass({

    create() {
        const result = this._super.apply(this, arguments);
        return result;
    },

    // Load an markeplace item
    find(subsId, opts) {
        let url = Nilavu.getURL("/subscriptions/") + subsId;

        const data = {};
        if (opts.provider) {
            data.provider = opts.provider;
        }

        // Check the preload store. If not, load it via JSON
        return Nilavu.ajax(url + ".json", {
            data: data
        });
    },

});

export default Subscriptions;
