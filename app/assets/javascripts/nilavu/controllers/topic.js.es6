import BufferedContent from 'nilavu/mixins/buffered-content';
import {
    spinnerHTML
} from 'nilavu/helpers/loading-spinner';
import Topic from 'nilavu/models/topic';
import {
    popupAjaxError
} from 'nilavu/lib/ajax-error';
import computed from 'ember-addons/ember-computed-decorators';
import NilavuURL from 'nilavu/lib/url';
import showModal from 'nilavu/lib/show-modal';

export default Ember.Controller.extend(BufferedContent, {
    needs: ['application', 'modal'],
    progress: 10,
    selectedTab: null,
    panels: null,
    rerenderTriggers: ['isUploading'],


    _initPanels: function() {
        this.set('panels', []);
        this.set('selectedTab', 'info');
    }.on('init'),

    infoSelected: function() {
        return this.selectedTab == 'info';
    }.property('selectedTab'),

    storageSelected: function() {
        return this.selectedTab == 'storage';
    }.property('selectedTab'),

    networkSelected: function() {
        return this.selectedTab == 'network';
    }.property('selectedTab'),

    cpuSelected: function() {
        return this.selectedTab == 'cpu';
    }.property('selectedTab'),

    ramSelected: function() {
        return this.selectedTab == 'ram';
    }.property('selectedTab'),

    keysSelected: function() {
        return this.selectedTab == 'keys';
    }.property('selectedTab'),

    logsSelected: function() {
        return this.selectedTab == 'logs';
    }.property('selectedTab'),

    title: Ember.computed.alias('fullName'),

    fullName: function() {
        var js = this._filterInputs("domain");
        return this.get('model.name') + "." + js;
    }.property('model.name'),

    hasInputs: Em.computed.notEmpty('model.inputs'),

    _filterInputs(key) {
        if (!this.get('hasInputs')) return "";
        if (!this.get('model.inputs').filterBy('key', key)[0]) return "";
        return this.get('model.inputs').filterBy('key', key)[0].value;
    },


    actions: {

        // VNC
        showVNC() {
            showModal('vnc', {
                url: this.get('vncUrl')
            }); // send the url
        },

        // START, STOP, RESTART, DELETE
        start() {


            //this.deleteTopic(); //change accordingly
        },

        stop() {
            const topic = this.get('model');
            topic.archiveMessage().then(() => {
                this.gotoInbox(topic.get("inboxGroupName"));
            });
        },

        restart() {
            const topic = this.get('model');
            topic.moveToInbox().then(() => {
                this.gotoInbox(topic.get("inboxGroupName"));
            });
        },

        destroy() {
           //bootbox.confirm(I18n.t("post.delete.confirm", { count: this.get('selectedPostsCount') }), result => {
               //if (result) {

                    // If all posts are selected, it's the same thing as deleting the topic
                    if (this.get('allPostsSelected')) {
                        return this.deleteTopic();
                    }

                    const selectedPosts = this.get('selectedPosts');
                    const selectedReplies = this.get('selectedReplies');
                    const postStream = this.get('model.postStream');
                    const deleted_by=this.get('deleted_by')

                    Nilavu.Topic.destroy(deleted_by);

                //}
           //})
        },

        snapshot(post) {
            if (!Nilavu.User.current()) {
                return bootbox.alert(I18n.t('post.controls.edit_anonymous'));
            }

            // check if current user can edit post
            if (!post.can_edit) {
                return false;
            }

            const composer = this.get('controllers.composer'),
                composerModel = composer.get('model'),
                opts = {
                    post: post,
                    action: Composer.EDIT,
                    draftKey: post.get('topic.draft_key'),
                    draftSequence: post.get('topic.draft_sequence')
                };

            // Cancel and reopen the composer for the first post
            if (composerModel && (post.get('firstPost') || composerModel.get('editingFirstPost'))) {
                composer.cancelComposer().then(() => composer.open(opts));
            } else {
                composer.open(opts);
            }
        },

        attachIP() {
            if (!this.get('model.details.can_edit')) return false;

            this.set('editingTopic', true);
            return false;
        },

        resizeStorage(storage) {
            return storage.rebake();
        }
    },

    hasError: Ember.computed.or('model.notFoundHtml', 'model.message'),

    noErrorYet: Ember.computed.not('hasError'),

    loadingHTML: function() {
        return spinnerHTML;
    }.property()

});
