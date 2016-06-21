import {flushMap} from 'nilavu/models/store';
import RestModel from 'nilavu/models/rest';
import {propertyEqual} from 'nilavu/lib/computed';
import {longDate} from 'nilavu/lib/formatter';
import computed from 'ember-addons/ember-computed-decorators';
const Buckets = Nilavu.Model.extend({

    store() {
        alert("model");

        const self = this;
        return Nilavu.ajax('/storages.json', {
            type: 'POST'
        }).then(function() {
            //self.updateFromJson(bill_json);
        });

    }

});
export default Buckets;
