import showModal from 'nilavu/lib/show-modal';
import Bucketfiles from 'nilavu/models/bucketfiles';

export default Nilavu.Route.extend({

    redirect() {
        return this.redirectIfLoginRequired();
    },

    setupParams(bucketfiles, params) {
        return bucketfiles;
    },

    model(params) {
        const self = this;
        var bucketfiles = this.store.createRecord('bucketfiles');
        return bucketfiles.reload(params.id).then(function(result) {
            self.set('loading', false);
            return self.setupParams(bucketfiles, params);
        }).catch(function(e) {
            self.set('loading', false);
            self.notificationMessages.error(I18n.t("storages.onboard_error"));
        });
    },

    setupController(controller, model) {
        const storageController = this.controllerFor('storages-show');
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

        this.render('storages/show', {
            controller: 'storages-show',
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
