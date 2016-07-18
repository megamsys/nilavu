export default Ember.Component.extend({
    //tagName: 'tr',

    content_reattach_ip: function() {
        return I18n.t("vm_management.network.content_reattach_ip");
    }.property(),
});
