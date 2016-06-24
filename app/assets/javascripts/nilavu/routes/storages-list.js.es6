import NilavuURL from 'nilavu/lib/url';
import Buckets from 'nilavu/models/buckets';

export default Nilavu.Route.extend({

    redirect() {
        return this.redirectIfLoginRequired();
    },

    beforeModel(transition) {
        const self = this,
            bucketController = this.controllerFor('storages-list');
        //TO-DO VINO: ADD error handling here to show the error.
        const promise = Buckets.list().then(function(result) {
            if (result.success) {
                bucketController.setProperties({
                    model: result
                });
                //alert(result)
            } else {
                self.notificationMessages.error(I18n.t("storages.onboard_error"));
            }
        }).catch(function(e) {
            self.notificationMessages.error(I18n.t("storages.onboard_error"));
        });
    },

    setupController(controller, params) {
        params = params || {};
        params.forceLoad = true;
    },

    deactivate() {
        this._super();
    },

    actions: {

        loading() {
            this.controllerFor("storages-list").set("loading", true);
            return true;
        },

        loadingComplete() {
            this.controllerFor("storages-list").set("loading", false);
        },

        didTransition() {
            this.send("loadingComplete");
            return true;
        },

    },

    _save() {
        this.transitionTo('storages.files');
    },


    renderTemplate() {
        this.render('navigation/default', {
            outlet: 'navigation-bar'
        });

        this.render('storages/list', {
            controller: 'storages-list',
            outlet: 'list-container'
        });
    }
});
