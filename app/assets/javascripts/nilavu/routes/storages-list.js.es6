import NilavuURL from 'nilavu/lib/url';
import Buckets from 'nilavu/models/buckets';

export default Nilavu.Route.extend({

    redirect() {
        return this.redirectIfLoginRequired();
    },

    setupParams(buckets, params) {
        return buckets;
    },

    model(params) {
        const self = this;

        var buckets = this.store.createRecord('buckets');

        return buckets.reload().then(function(result) {
            self.set('loading', false);
            return self.setupParams(buckets, params);
        }).catch(function(e) {
            self.set('loading', false);
            self.notificationMessages.error(I18n.t("storages.onboard_error"));
        });
    },

    setupController(controller, model) {
        const storageController = this.controllerFor('storages-list');
        storageController.setProperties({
            model
        });
    },

    activate() {
        this._super();
    },

    deactivate() {
        this._super();
    },

    renderTemplate() {
        this.render('navigation/default', {
            outlet: 'navigation-bar'
        });

        this.render('storages/list', {
            controller: 'storages-list',
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
