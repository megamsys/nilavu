import NilavuURL from 'nilavu/lib/url';
import Subscriptions from 'nilavu/models/subscriptions';


export default Nilavu.Route.extend({

    redirect() {
        return this.redirectIfLoginRequired();
    },

    setupParams(subscriptions, params) {
        return subscriptions;
    },

    model(params) {
        const self = this;

        var subscriptions = this.store.createRecord('subscriptions');
        return subscriptions.reload().then(function(result) {
            self.set('loading', false);
            return self.setupParams(subscriptions, params);
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
        this.render('billers/activate', {
            controller: 'subscriptions'
        });
    }

});
