import computed from "ember-addons/ember-computed-decorators";

export default Ember.Controller.extend({
  needs: ['discovery', 'discovery/topics'],

  @computed()
  categories() {
    return Nilavu.Category.list();
  },


  @computed("filterMode")
  navItems(filterMode = "dashboard") {
    if (filterMode.indexOf("top/") === 0) { filterMode = filterMode.replace("top/", ""); }

    return Nilavu.NavItem.buildList(null, { filterMode });
  }

});
