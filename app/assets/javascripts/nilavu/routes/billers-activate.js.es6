import NilavuURL from 'nilavu/lib/url';
import Billers from 'nilavu/models/billers';


export default Nilavu.Route.extend({

    redirect() {
        return this.redirectIfLoginRequired();
    },

    setupParams(billers, params) {
        return billers;
    },

    model(params) {
        const self = this;
        var billers = this.store.createRecord('billers');
        return billers.reload().then(function(result) {
            self.set('loading', false);
            return self.setupParams(billers, params);
        }).catch(function(e) {
            self.set('loading', false);
        });
    },

    setupController(controller, model) {
        const billersController = this.controllerFor('billers');
        billersController.setProperties({
          model
        });
    },

    activate() {
        this._super();
    },

    renderTemplate() {
        this.render('billers/activate', {
            controller: 'billers'
        });
    }

});
