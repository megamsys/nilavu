import NilavuURL from 'nilavu/lib/url';
import LaunchStatus from 'nilavu/models/launch-status';

// This route is used for retrieving a topic/:id based on params - id
export default Nilavu.Route.extend({

    redirect() {
        return this.redirectIfLoginRequired();
    },

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
        const oneOfSuccess = LaunchStatus.create({event_type: topic.status}).get('successKey');
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
            topicappController = this.controllerFor('topic-app').setProperties({model: topic});
        params.forceLoad = false;
        const promise = topic.reload().then(function(result) {
            topicappController.setProperties({model: topic});
            self.set('loading', false);
        }).catch(function(e) {
            self.notificationMessages.error(I18n.t("vm_management.topic_load_error"));
            self.set('loading', false);
        });
    },

    renderTemplate() {
        this.render('navigation/default', {outlet: 'navigation-bar'});

        this.render('topic/app', {
            controller: 'topic-app',
            outlet: 'list-container'
        });
    }

});
