import NilavuURL from 'nilavu/lib/url';
import Billing from 'nilavu/models/billing';

export default Nilavu.Route.extend({
    redirect() {
        return this.redirectIfLoginRequired(); },


    setupParams(billing, params) {
        return billing;
    },


    model(params) {
        const self = this;

        var billing = this.store.createRecord('billing');

        return billing.reload().then(function(result) {
            self.set('loading', false);
            return self.setupParams(billing, params);
        }).catch(function(e) {
            self.set('loading', false);
        });
    },

    setupController(controller, model) {
        const billController = this.controllerFor('billing');
        billController.setProperties({
            model
        });
    },

    activate() {
        this._super();
    },

    renderTemplate() {
        this.render('navigation/default', {
            outlet: 'navigation-bar'
        });

        this.render('billing/show', {
            controller: 'billing',
            outlet: 'list-container'
        });
    }
});
