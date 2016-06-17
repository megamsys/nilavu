// This route is used for showing a predeploy for
// topic/:id/predeploy based on params - id
export default Nilavu.Route.extend({
    redirect() {  return this.redirectIfLoginRequired(); },

    setupController(controller, model) {
        controller.setProperties({ model: model });
        controller.subscribe();
        const postStream = controller.get('model.postStream');
        postStream.cancelFilter();
    },

    deactivate() {
        this._super();
        const topicDeployController = this.controllerFor('topic-predeploy');
        topicDeployController.unsubscribe();
    },


    renderTemplate() {
        this.render('navigation/default', {
            outlet: 'navigation-bar'
        });

        this.render('topic/predeploy', {
            controller: 'topic-predeploy',
            outlet: 'list-container'
        });
    }

});
