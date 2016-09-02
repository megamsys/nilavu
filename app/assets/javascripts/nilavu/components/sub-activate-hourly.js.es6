import NilavuURL from 'nilavu/lib/url';
import {
    buildSubPanel
} from 'nilavu/components/sub-panel';
import computed from 'ember-addons/ember-computed-decorators';
import FlavorCost from 'nilavu/models/flavor_cost';

export default buildSubPanel('hourly', {

  supportEmail: function() {
      return Nilavu.SiteSettings.support_email;
  }.property(),

  supportPhoneNumber: function() {
      return Nilavu.SiteSettings.support_phonenumber;
  }.property(),

  //This has to be generic as we would support multiple billers
  whmcsClientAreaRedirect: function() {
      return Nilavu.SiteSettings.whmcs_clientarea_url;
  }.property(),

actions: {
  addFunds: function() {
      NilavuURL.redirectTo(this.get('whmcsClientAreaRedirect'));
  }
},


});
