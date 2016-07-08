import NilavuURL from 'nilavu/lib/url';
import { setting } from 'nilavu/lib/computed';

export default Ember.Component.extend({
  classNames: [],

  targetUrl: function() {
    // For overriding by customizations
    return '/';
  }.property(),

  linkUrl: function() {
    return Nilavu.getURL(this.get('targetUrl'));
  }.property('targetUrl'),

  showSmallLogo: function() {
    return !this.site.mobileView && this.get("minimized");
  }.property("minimized"),

  showMobileLogo: function() {
    return this.site.mobileView && !Ember.isBlank(this.get('mobileBigLogoUrl'));
  }.property(),

  smallLogoUrl: setting('logo_small_url'),
  bigLogoUrl: setting('logo_url'),
  mobileBigLogoUrl: setting('mobile_logo_url'),
  title: setting('title'),
  logoUrl: setting('logos_url'),

  click: function(e) {
    // if they want to open in a new tab, let it so
    if (e.shiftKey || e.metaKey || e.ctrlKey || e.which === 2) { return true; }

    e.preventDefault();

    NilavuURL.routeTo(this.get('targetUrl'));
    return false;
  }
});
