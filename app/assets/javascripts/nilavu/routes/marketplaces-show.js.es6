import NilavuURL from 'nilavu/lib/url';
import Marketplaces from 'nilavu/models/marketplaces';


export default Nilavu.Route.extend({

    redirect() {
        return this.redirectIfLoginRequired();
    },

    setupParams(marketplaces, params) {
        return marketplaces;
    },

    model(params) {
        const self = this;

        var marketplaces = this.store.createRecord('marketplaces');

        return marketplaces.reload().then(function(result) {
            self.set('loading', false);
            return self.setupParams(marketplaces, params);
        }).catch(function(e) {
            self.set('loading', false);
        });
    },



    setupController(controller, model) {
        const mktController = this.controllerFor('marketplaces');
        mktController.setProperties({
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

        this.render('marketplaces/show', {
            controller: 'marketplaces',
            outlet: 'list-container'
        });
    },
    actions: {
      didTransition() {
        this.controllerFor("application").set("showFooter", true);
        return true;
      }
    }

});
