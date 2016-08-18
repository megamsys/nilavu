import NilavuURL from 'nilavu/lib/url';
import LaunchStatus from 'nilavu/models/launch-status';

// This route is used for retrieving a topic/:id based on params - id
export default Nilavu.Route.extend({

    setupParams(topic, params) {
        return topic;
    },

    model(params) {
        const self = this;
       const topic = this.modelFor('topic');

        return topic.reload().then(function(result) {
            self.set('loading', false);
            return self.setupParams(topic, params);
        }).catch(function(e) {
            self.set('loading', false);
        });
    },

    setupController(controller, model) {
        const topicController = this.controllerFor('topic');
        topicController.setProperties({
             topic : model
        });
    },


    renderTemplate() {
        this.render('navigation/default', {outlet: 'navigation-bar'});

        this.render('topic/app', {
            controller: 'topic',
            outlet: 'list-container'
        });
    }

});
