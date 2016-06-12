export default Ember.Component.extend({

  unitFlavourChanged: function() {

    const uf=this.get('unitFlavor');
      this.set('unitFlav', this.get('unitFlavor'));
      this.rerender();
  }.observes('unitFlavor'),

  fcpu: function() {
    alert("cpu");
    alert(this.get('unitFlav'));
      return this.get('unitFlav').cpu();
  }.property('unitFlav'),

  fmemory: function() {
    alert("memory");
    alert(this.get('unitFlav'));
      return this.get('unitFlav').memory();
  }.property('unitFlav'),

  fstorage: function() {
    alert("stoage");
    alert(this.get('unitFlav'));
      return this.get('unitFlav').storage();
  }.property('unitFlav'),
});
