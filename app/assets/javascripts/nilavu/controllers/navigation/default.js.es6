import computed from "ember-addons/ember-computed-decorators";

export default Ember.Controller.extend({
  needs: ['discovery', 'discovery/topics'],

  @computed()
  categories() {
    console.log("Nav.Default controller: lets show the categories");
    return Nilavu.Category.list();
  },

  @computed("filterMode")
  navItems(filterMode) {
    console.log("Nav.Default controller lets show the filterMode");

    // we don't want to show the period in the navigation bar since it's in a dropdown
    if (filterMode.indexOf("top/") === 0) { filterMode = filterMode.replace("top/", ""); }
    return Nilavu.NavItem.buildList(null, { filterMode });
  }

});
