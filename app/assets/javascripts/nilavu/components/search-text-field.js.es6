import computed from 'ember-addons/ember-computed-decorators';
import { on } from 'ember-addons/ember-computed-decorators';
import TextField from 'nilavu/components/text-field';

export default TextField.extend({
  classNameBindings: [':form-control',':flat'],

  @computed('searchService.searchContextEnabled')
  placeholder(searchContextEnabled) {
    return I18n.t('search.title');
  },

  @on("didInsertElement")
  becomeFocused() {
    if (!this.get('hasAutofocus')) { return; }
    // iOS is crazy, without this we will not be
    // at the top of the page
    $(window).scrollTop(0);
    this.$().focus();
  }
});
