export default Ember.Component.extend({
unitFlavourChanged: function() {
        this.set('unitFlav', this.get('unitFlavors.micro'));
        alert("unitflavchange"+JSON.stringify(this.get('unitFlav')));
    }.observes('unitFlavors'),

    fcpu: function() {
     //return this.get('unitFlavor');
     alert("cpu"+JSON.stringify(this.get('unitFlav')));
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
