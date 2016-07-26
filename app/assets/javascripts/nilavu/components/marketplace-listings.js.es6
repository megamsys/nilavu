import { on, observes } from 'ember-addons/ember-computed-decorators';
import showModal from 'nilavu/lib/show-modal';

import OpenComposer from "nilavu/mixins/open-composer";

export default Ember.Component.extend({

    mktListings: function() {
        const grouped_results = this.get('results');
        const member = this.get('member');
        let otmap = [];
        for (var order in grouped_results) {
            if (order == member.order) {
                otmap = grouped_results[order];
                break;
            }
        }
        return otmap;
    }.property('member', 'results'),

    actions: {

      createTopic(item) {
        this.sendAction('action', item);
      },

    }

});
