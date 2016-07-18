export default Ember.Controller.extend({
    userActionType: null,
    needs: ["application", "user"],
    currentPath: Em.computed.alias('controllers.application.currentPath'),
    viewingSelf: Em.computed.alias("controllers.user.viewingSelf"),

    _showFooter: function() {
        var showFooter;
        if (this.get("userActionType")) {
            const stat = _.find(this.get("model.stats"), { action_type: this.get("userActionType") });
            showFooter = stat && stat.count <= this.get("model.stream.itemsLoaded");
        } else {
            showFooter = this.get("model.statsCountNonPM") <= this.get("model.stream.itemsLoaded");
        }
        this.set("controllers.application.showFooter", showFooter);
    }.observes("userActionType", "model.stream.itemsLoaded"),

    actions: {}

});
