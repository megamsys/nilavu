import NilavuURL from 'nilavu/lib/url';

const configs = {
  "faq": "faq_url",
  "tos": "tos_url",
  "privacy": "privacy_policy_url"
};

export default function(page) {
  return Nilavu.Route.extend({
    renderTemplate() {
      this.render("static");
    },

    beforeModel(transition) {
      const configKey = configs[page];
      if (configKey && Nilavu.SiteSettings[configKey].length > 0) {
        transition.abort();
        NilavuURL.redirectTo(Nilavu.SiteSettings[configKey]);
      }
    },

    activate() {
      this._super();
      // Scroll to an element if exists
      NilavuURL.scrollToId(document.location.hash);
    },

    model() {
      return Nilavu.StaticPage.find(page);
    },

    setupController(controller, model) {
      this.controllerFor("static").set("model", model);
    },

    actions: {
      didTransition() {
        this.controllerFor("application").set("showFooter", true);
        return true;
      }
    }
  });
};
