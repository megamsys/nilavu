/**
  A data model representing a group of UserActions
**/
export default Nilavu.Model.extend({
  push: function(item) {
    if (!this.items) {
      this.items = [];
    }
    return this.items.push(item);
  }
});


