import { default as computed, observes } from "ember-addons/ember-computed-decorators";
import NilavuURL from 'nilavu/lib/url';

export default Ember.Component.extend({
  tagName: 'ul',
  classNameBindings: [':page-sidebar-menu'],
  id: 'navigation-bar',

  newTitle: function() {
     return I18n.t('launcher.new');
  }.property(),
  
  @observes("expanded")
  closedNav() {
    if (!this.get('expanded')) {
      this.ensureDropClosed();
    }
  },

  ensureDropClosed() {
    if (!this.get('expanded')) {
      this.set('expanded',false);
    }
    $(window).off('click.navigation-bar');
    NilavuURL.appEvents.off('dom:clean', this, this.ensureDropClosed);
  },

  actions: {

    newLaunch() {
      this.container.lookup('controller:discovery.topics').send("createTopic");
    },

    toggleDrop() {
      this.set('expanded', !this.get('expanded'));

      if (this.get('expanded')) {
        NilavuURL.appEvents.on('dom:clean', this, this.ensureDropClosed);

        Em.run.next(() => {
          if (!this.get('expanded')) { return; }

          this.$('.drop a').on('click', () => {
            this.$('.drop').hide();
            this.set('expanded', false);
            return true;
          });

          $(window).on('click.navigation-bar', () => {
            this.set('expanded', false);
            return true;
          });
        });
      }
    }
  }
});
