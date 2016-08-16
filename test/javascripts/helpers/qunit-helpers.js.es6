/* global asyncTest, fixtures */

import sessionFixtures from 'fixtures/session-fixtures';
import siteFixtures from 'fixtures/site-fixtures';
import HeaderComponent from 'nilavu/components/site-header';
import { forceMobile, resetMobile } from 'nilavu/lib/mobile';

function currentUser() {
  return Nilavu.User.create(sessionFixtures['/session/current.json'].current_user);
}

function logIn() {
  Nilavu.User.resetCurrent(currentUser());
}

const Plugin = $.fn.modal;
const Modal = Plugin.Constructor;

function AcceptanceModal(option, _relatedTarget) {
  return this.each(function () {
    var $this   = $(this);
    var data    = $this.data('bs.modal');
    var options = $.extend({}, Modal.DEFAULTS, $this.data(), typeof option === 'object' && option);

    if (!data) $this.data('bs.modal', (data = new Modal(this, options)));
    data.$body = $('#ember-testing');

    if (typeof option === 'string') data[option](_relatedTarget);
    else if (options.show) data.show(_relatedTarget);
  });
}

window.bootbox.$body = $('#ember-testing');
$.fn.modal = AcceptanceModal;

function acceptance(name, options) {
  module("Acceptance: " + name, {
    setup() {
      resetMobile();

      // For now don't do scrolling stuff in Test Mode
      HeaderComponent.reopen({examineDockHeader: Ember.K});

      const siteJson = siteFixtures['site.json'].site;
      if (options) {
        if (options.setup) {
          options.setup.call(this);
        }

        if (options.mobileView) {
          forceMobile();
        }

        if (options.loggedIn) {
          logIn();
        }

        if (options.settings) {
          Nilavu.SiteSettings = jQuery.extend(true, Nilavu.SiteSettings, options.settings);
        }

        if (options.site) {
          Nilavu.Site.resetCurrent(Nilavu.Site.create(jQuery.extend(true, {}, siteJson, options.site)));
        }
      }

      Nilavu.reset();
    },

    teardown() {
      if (options && options.teardown) {
        options.teardown.call(this);
      }
      Nilavu.User.resetCurrent();
      Nilavu.Site.resetCurrent(Nilavu.Site.create(jQuery.extend(true, {}, fixtures['site.json'].site)));

      Nilavu.reset();
    }
  });
}

function controllerFor(controller, model) {
  controller = Nilavu.__container__.lookup('controller:' + controller);
  if (model) { controller.set('model', model ); }
  return controller;
}

function asyncTestNilavu(text, func) {
  asyncTest(text, function () {
    var self = this;
    Ember.run(function () {
      func.call(self);
    });
  });
}

function fixture(selector) {
  if (selector) {
    return $("#qunit-fixture").find(selector);
  }
  return $("#qunit-fixture");
}

function present(obj, text) {
  ok(!Ember.isEmpty(obj), text);
}

function blank(obj, text) {
  ok(Ember.isEmpty(obj), text);
}

export { acceptance,
         controllerFor,
         asyncTestNilavu,
         fixture,
         logIn,
         currentUser,
         blank,
         present };
