import { flushMap } from 'nilavu/models/store';
import RestModel from 'nilavu/models/rest';
import { propertyEqual } from 'nilavu/lib/computed';
import { longDate } from 'nilavu/lib/formatter';
import computed from 'ember-addons/ember-computed-decorators';
import NilavuURL from 'nilavu/lib/url';

const Ssh = RestModel.extend({
    message: null,
    errorLoading: false,

    updateFromJson(json) {
        const self = this;
        self.set('ssh', json);

        const keys = Object.keys(json);
        keys.forEach(key => { self.set(key, json[key]) });
    },

    reload() {
        const self = this;
        return Nilavu.ajax("/sshkeys", { type: 'GET' }).then(function(ssh_json) {
            self.updateFromJson(ssh_json);
        });
    }
});


export default Ssh;
