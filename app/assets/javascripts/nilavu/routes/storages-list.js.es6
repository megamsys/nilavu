import NilavuURL from 'nilavu/lib/url';
import Buckets from 'nilavu/models/buckets';

export default Nilavu.Route.extend({

    redirect() {
        return this.redirectIfLoginRequired();
    },

    model(params) {
        return params;
    },

    setupController(controller, params) {
        params = params || {};
        const self = this,
            bucketController = this.controllerFor('buckets-list');

        params.forceLoad = true;

        //TO-DO VINO: ADD error handling here to show the error.
        const promise = Buckets.list().then(function(result) {
            if (!result.failed) {
                bucketController.setProperties({
                    model: result
                });
                self.notifications.success(result.message);
            } else {
                self.notificationMessages.error(result.message);
            }
            self.set('loading', false);
        }).catch(function(e) {
            self.set('loading', false);
            self.notificationMessages.error(I18n.t("ssh_keys.download_error"));
        });

    },

    deactivate() {
        this._super();
    },

    actions: {

        loading() {
            this.controllerFor("buckets-list").set("loading", true);
            return true;
        },

        loadingComplete() {
            this.controllerFor("buckets-list").set("loading", false);
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

        this.render('storages/show', {
            controller: 'storages',
            outlet: 'list-container'
        });
    }
});
