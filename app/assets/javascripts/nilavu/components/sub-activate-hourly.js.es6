import NilavuURL from 'nilavu/lib/url';
import {
    buildSubPanel
} from 'nilavu/components/sub-panel';
import computed from 'ember-addons/ember-computed-decorators';
import FlavorCost from 'nilavu/models/flavor_cost';


export default buildSubPanel('hourly', {
  needs: ['subscriptions'],
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
    const self = this;
      // NilavuURL.redirectTo(this.get('whmcsClientAreaRedirect'));
      return Nilavu.ajax("/billers", {
          type: 'POST'
      }).then(function(result) {
          self.set('formSubmitted', false);
          var rs = result.subscriber;
          if (Em.isEqual(rs.result, "success")) {
              NilavuURL.routeTo('/');
          } else {
            console.log(JSON.stringify(rs));
              self.notificationMessages.error(I18n.t(rs.error));
          }
      });
  }
},


});
