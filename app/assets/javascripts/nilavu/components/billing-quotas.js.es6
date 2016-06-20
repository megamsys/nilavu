export default Ember.Component.extend({
    unitFlavourChanged: function() {
        const uf = this.get('unitFlavor');
        this.set('unitFlav', this.get('unitFlavor'));
        this.rerender();
    }.observes('unitFlavor'),

    fcpu: function() {
        return this.get('unitFlav').cpu();
    }.property('unitFlav'),

    fmemory: function() {
        return this.get('unitFlav').memory();
    }.property('unitFlav'),

    fstorage: function() {
        return this.get('unitFlav').storage();
    }.property('unitFlav'),

});
