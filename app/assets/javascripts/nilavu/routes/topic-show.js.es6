import NilavuURL from 'nilavu/lib/url';
import LaunchStatus from 'nilavu/models/launch-status';

// This route is used for retrieving a topic/:id based on params - id
export default Nilavu.Route.extend({

    // Avoid default model hook
    model(params) {
        return params;
    },

    afterModel() {
        const topic = this.modelFor('topic');
        if (this.showPredeployer(topic)) {
            this.replaceWith(topic.url() + '/predeploy', topic);
        }
    },

    showPredeployer: function(topic) {
        if (topic && topic.predeploy_finished) {
            return false;
        }
        const oneOfSuccess = LaunchStatus.create({
            event_type: topic.status
        }).get('successKey');
        if (topic && oneOfSuccess) {
            return false;
        }

        //    const oneOfError   = LaunchStatus.TYPES_ERROR.indexOf(topic.status) >=0;
        return true;
    },

    setupController(controller, params) {
        params = params || {};
        const self = this,
            topic = this.modelFor('topic'),
            topicController = this.controllerFor('topic');

        params.forceLoad = false;

        //TO-DO RAJ: ADD error handling here to show the error.
        const promise = topic.reload().then(function(result) {
            topicController.setProperties({
                model: topic
            });
            self.set('loading', false);
        }).catch(function(e) {
            //    alert("RAJ HANDLE ERR (check edit-category)\n" + e);
            self.set('loading', false);
        });

        self.controllerFor('navigation/default').set('filterMode', "top");
    },

    renderTemplate() {
        this.render('navigation/default', {
            outlet: 'navigation-bar'
        });

        this.render('topic/show', {
            controller: 'topic',
            outlet: 'list-container'
        });
    }



});
