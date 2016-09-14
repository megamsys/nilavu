import NilavuURL from 'nilavu/lib/url';
import Subscriptions from 'nilavu/models/subscriptions';


export default Nilavu.Route.extend({

    redirect() {
        return this.redirectIfLoginRequired();
    },

    setupParams(subs, params, result) {
        return result;
    },

    model(params) {
        const self = this;
        var subs = this.store.createRecord('subscriptions');

        return subs.check().then(function(result) {
            self.set('loading', false);
            return self.setupParams(subs, params, result);
        }).catch(function(e) {
            self.set('loading', false);
        });
    },

    setupController(controller, model) {
        const subsController = this.controllerFor('subscriptions');
        subsController.setProperties({
            model
        });
    },

    activate() {
        this._super();
    },

    renderTemplate() {
        this.render('subscriptions/show', {
            controller: 'subscriptions'
        });
    }

});
