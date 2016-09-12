// This route is used for showing a predeploy for
// topic/:id/predeploy based on params - id
export default Nilavu.Route.extend({
    redirect() {
        return this.redirectIfLoginRequired();
    },

    setupController(controller, model) {
        const self = this;        
        const promise = model.reload().then(function(result) {
          controller.setProperties({model: model});
            self.set('loading', false);
            controller.subscribe();
            const postStream = controller.get('model.postStream');
            postStream.cancelFilter();
        }).catch(function(e) {
            self.notificationMessages.error(I18n.t("vm_management.topic_load_error"));
            self.set('loading', false);
        });
    },

    deactivate() {
        this._super();
        const topicDeployController = this.controllerFor('topic-predeploy');
        topicDeployController.unsubscribe();
    },

    renderTemplate() {
        this.render('navigation/default', {outlet: 'navigation-bar'});

        this.render('topic/predeploy', {
            controller: 'topic-predeploy',
            outlet: 'list-container'
        });
    }

});
