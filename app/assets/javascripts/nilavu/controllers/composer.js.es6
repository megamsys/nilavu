import NilavuURL from 'nilavu/lib/url';
import Draft from 'nilavu/models/draft';
import Composer from 'nilavu/models/composer';
import {
    default as computed,
    observes
} from 'ember-addons/ember-computed-decorators';


export default Ember.Controller.extend({
    needs: ['modal', 'topic', 'application'],

    isUploading: false,
    topic: null,

    _initializeSimilar: function() {
        this.set('similarTopics', []);
    }.on('init'),

    actions: {

        cancel() {
            this.cancelComposer();
        },

    },


    open(opts) {
        opts = opts || {};

        self = this;

        let composerModel = this.get('model');

        self.cancelComposer().then(() => {});

        return new Ember.RSVP.Promise(function(resolve, reject) {
            Draft.get(opts.draftKey).then(function(data) {

                opts.draftSequence = data.random_name;
                opts.metaData = data;
                opts.draftKey = data.domain;

                self._setModel(composerModel, opts);
                resolve(self.get('model'));
            });
        });
    },


    // Given a potential instance and options, set the model for this composer.
    _setModel(composerModel, opts) {
        composerModel = composerModel || this.store.createRecord('composer');

        opts.draftKey = "new-topic";

        composerModel.open(opts);

        this.set('model', composerModel);

    },


    cancelComposer() {
        const self = this;

        return new Ember.RSVP.Promise(function(resolve) {
            if (self.get('model.hasMetaData') || self.get('model.metaData.launchoption')) {
                self.get('model').clearState();
                self.close();
                resolve();
            }
        });
    },

    shrink() {
        this.close();
    },


    close() {
        this.setProperties({ model: null, lastValidatedAt: null });
    },

    visible: function() {
        var state = this.get('model.composeState');
        return state && state !== 'closed';
    }.property('model.composeState')

});
