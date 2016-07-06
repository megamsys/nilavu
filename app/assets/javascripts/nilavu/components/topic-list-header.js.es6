export default Ember.Component.extend({

  actions: {

    changeGridView() {
      this.set("gridView", true);
      this.set("listView", false);
    },

    changeListView() {
      this.set("listView", true);
      this.set("gridView", false);
    },

  }

});
