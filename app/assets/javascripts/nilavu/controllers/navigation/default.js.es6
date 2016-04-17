import computed from "ember-addons/ember-computed-decorators";

export default Ember.Controller.extend({
  needs: ['discovery', 'discovery/topics'],

  @computed()
  categories() {
    return Nilavu.Category.list();
  },

  @computed("filterMode")
  navItems(filterMode) {
    console.log(">  navItems: "+filterMode);
    if (filterMode.indexOf("top/") === 0) { filterMode = filterMode.replace("top/", ""); }
    console.log("   navItems: "+ Nilavu.NavItem.buildList(null, {filterMode}));
    return Nilavu.NavItem.buildList(null, { filterMode });
  }

});
