import ModalFunctionality from 'nilavu/mixins/modal-functionality';
import NilavuURL from 'nilavu/lib/url';
import {observes} from 'ember-addons/ember-computed-decorators';
import {extractError} from 'nilavu/lib/ajax-error';

export default Ember.Controller.extend(ModalFunctionality, {
    selectedTab: null,
    saving: false,
    panels: null,
    loading: false,
    editLaunching: false,
    isVirtualMachine: false,
    gotoSummarize: false,
    summarizeButtonVisible: true,
    summarizeVisible: true,

    _initPanels: function() {
        this.set('panels', []);
    }.on('init'),

    marketplaceItemSelected: function() {
        return Em.isEmpty(this.get("selectedItem"));
    }.property('selectedItem'),

    generalSelected: function() {
        return this.selectedTab == 'general';
    }.property('selectedTab'),

    //hidden nextSummarize button~
    selectionSelected: function() {
        return this.selectedTab == 'selection';
    }.property('selectedTab'),

    @observes('summarizeVisible')setSummarizeButtonValue: function() {
        this.set('selectionSelected', this.get('summarizeVisible'));
    },

    summarySelected: function() {
        return this.selectedTab == 'summary';
    }.property('selectedTab'),

    category: Ember.computed.alias('model.metaData'),
    selectedItem: Ember.computed.alias('marketplaceItem'),

    onShow() {
        this.changeSize();
        this.titleChanged();
    },

    hidemeClass: function() {
        if (Em.isEmpty(this.get("selectedItem"))) {
            return "hideme steps";
        } else {
            return "steps";
        }
    }.property(),

    changeSize: function() {
        if (this.get('selectionSelected') && (!this.get('isVirtualMachine'))) {
            this.set('controllers.modal.modalClass', 'edit-category-modal full');
        } else if (this.get('selectionSelected')) {
            this.set('controllers.modal.modalClass', 'edit-category-modal full');
        } else if (this.get('generalSelected')) {
            //$('.firstStep').slideToggle('fast');
            this.set('controllers.modal.modalClass', 'edit-category-modal full');
        } else {
            this.set('controllers.modal.modalClass', 'edit-category-modal full');
        }
    }.observes('isVirtualMachine', 'generalSelected', 'selectionSelected', 'summarySelected'),

    titleChanged: function() {
        this.set('controllers.modal.title', this.get('title'));
    }.observes('title'),

    resetForm() {
        if (this.get('category')) {}
    },

    title: function() {
        if (this.get('generalSelected') && (this.get('isVirtualMachine'))) {
            return I18n.t("launcher.title");
        } else if (this.get('selectionSelected')) {
            return I18n.t("launcher.selection_application_title");
        } else if (this.get('summarySelected')) {
            return I18n.t("launcher.summary_title");
        }
        return I18n.t("launcher.title");
    }.property('selectionSelected', 'summarySelected'),

    launchOption: function() {
        const option = this.get('category.launchoption') || "";
        return option.trim().length > 0
            ? option
            : I18n.t("launchoption.default");
    }.property('category.launchoption'),

    launchableChanged: function() {
        this.set('category.launchoption', this.get('launchOption'));
        if (this.get('launchOption').trim().length > 0) {
            const isVM = Ember.isEqual(this.get('launchOption').trim(), I18n.t('launcher.virtualmachines'));
            this.set('isVirtualMachine', isVM);
        }
        this.set('selectedTab', 'general');
        if (!this.editLaunching) {
            $(".hideme").slideToggle(250);
            this.toggleProperty('editLaunching');
        }
    }.observes('launchOption'),

    setLaunchable: function() {
        this.set('launchOption', this.get('selectedItemOption'));
    }.observes('selectedItemOption'),

    cookingChanged: function() {
        const launchable = this.get('launchOption') || "";
        this.set('category.launchoption', launchable);
        if (launchable.trim().length > 0) {
            this.set('selectedTab', 'selection');
            $('.firstStep').slideToggle('fast');
        }
    }.observes('cooking'),

    summarizingChanged: function() {
        this.set('selectedTab', 'summary');
    }.observes('summarizing'),

    versionChanged: function() {
        const versionable = this.get('category.versionoption') || "";
        let versionEntered = (versionable.trim().length > 0);
        if (!(this.get('selecting') == undefined)) {
            this.set('selecting', !versionEntered);
        }
    }.observes('category.versionoption'),

    summarizingChanging: function() {
        if (this.get('summarizing')) {
            if (this.get('category.keypairoption') && this.get('category.keypairnameoption')) {
                this.set('selecting', false);
            } else {
                //  this.notificationMessages.info(I18n.t('launcher.required_sshkey_missing'));
            }
        }
    }.observes('category.keypairoption', 'category.keypairnameoption'),

    disabled: function() {
        if (this.get('saving') || this.get('selecting')) {
            return true;
        }
        if (!this.get('category.unitoption')) {
            return true;
        }
        return false;
    }.property('saving', 'selecting', 'category.unitoption', 'category.keypairoption'),
    categoryName: function() {
        const name = this.get('name') || "";
        return name.trim().length > 0
            ? name
            : I18n.t("preview");
    }.property('name'),

    saveLabel: function() {
        if (this.get('saving'))
            return I18n.t("launcher.saving");

        if (this.get('summarySelected'))
            return I18n.t("launcher.launch")

        if (this.get('generalSelected') || this.get('selectionSelected'))
            return I18n.t("launcher.selecting")

        return I18n.t("launcher.launch");
    }.property('saving', 'generalSelected', 'selectionSelected', 'summarySelected'),

    shrink() {
        this.close();
    },

    close() {
        this.setProperties({model: null});
    },

    @observes('gotoSummarize')gotoSummarizePage: function() {
        this.send('nextSummarize');
    },

    actions: {
        nextCategory() {
            this.set('loading', true);
            const model = this.get('model');
            return Nilavu.ajax("/launchables/pools/" + this.get('category.launchoption') + ".json").then(result => {
                model.metaData.setProperties({cooking: result});
                this.setProperties({cooking: true, selecting: true, loading: false});
            });
        },

        nextSummarize() {
            this.set('loading', true);
            const model = this.get('model');

            return Nilavu.ajax("/launchables/summary.json").then(result => {
                model.metaData.setProperties({summarizing: result});
                this.setProperties({summarizing: true, selecting: true, loading: false});
            });
        },

        saveCategory() {
            const self = this,
                model = this.get('model');
            self.set('saving', true);

            this.get('model').save().then(function(result) {
                self.set('saving', false);
                self.send('closeModal');
                const slugId = result.id
                    ? result.id
                    : "";

                const slugsId = result.asms_id
                    ? result.asms_id
                    : "";

                if (result.id) {
                    var todo = self.store.createRecord('topic', {
                        id: slugId,
                        asms_id: slugsId
                    });

                    const promise = todo.reload().then(function(result) {
                      self.replaceWith('/t/' + slugId, todo);
                      self.notificationMessages.success(I18n.t('launcher.launched') + " " + slugId);
                    }).catch(function(e) {
                        self.notificationMessages.error(I18n.t("vm_management.topic_load_error"));
                    });                  
                } else {
                    NilavuURL.routeTo('/');
                    self.notificationMessages.warning(I18n.t('launcher.not_launched') + " " + slugId);
                }

            }).catch(function(error) {
                self.flash(extractError(error), 'error');
                self.set('saving', false);
                self.send('closeModal');
                self.notificationMessages.error(I18n.t('launcher.not_launched'));
            }). finally(function() {
                self.shrink();
            });

        }
    }

});
