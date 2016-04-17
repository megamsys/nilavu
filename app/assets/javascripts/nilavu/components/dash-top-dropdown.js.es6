import DropdownButton from 'nilavu/components/dropdown-button';
import computed from "ember-addons/ember-computed-decorators";

export default DropdownButton.extend({
  buttonExtraClasses: 'btn-menu-top',
  title: '',
  text: I18n.t('user.new'),
  classNames: [],

  @computed()
  dropDownContent() {
    const items = [
    /*  { id: 'create',
        title: I18n.t('user.new_torpedo_app'),
        description: I18n.t('user.new_torpedo_app.create_long'),
        styleClasses: 'leftnav_app_reverse pull-left' }*/
    ];
    return items;
  },

  actionNames: {
    create: 'newLaunch'
  },

  clicked(id) {
    this.sendAction('actionNames.' + id);
  }
});
