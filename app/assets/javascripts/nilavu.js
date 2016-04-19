/*global Favcount:true*/
var NilavuResolver = require('nilavu/ember/resolver').default;

// Allow us to import Ember
define('ember', ['exports'], function(__exports__) {
  __exports__.default = Ember;
});


window.Nilavu = Ember.Application.createWithMixins(Nilavu.Ajax, {
  LOG_ACTIVE_GENERATION: true,
  LOG_VIEW_LOOKUPS: true,
  LOG_BINDINGS: true,
  LOG_TRANSITIONS: true,
  LOG_TRANSITIONS_INTERNAL: true,
  LOG_STACKTRCE_ON_DEPRECATION: true,

  rootElement: '#main',
  _docTitle: document.title,

  getURL: function(url) {
    if (!url) return url;

    // if it's a non relative URL, return it.
    if (url !== '/' && !/^\/[^\/]/.test(url)) return url;

    if (url.indexOf(Nilavu.BaseUri) !== -1) return url;
    if (url[0] !== "/") url = "/" + url;

    return Nilavu.BaseUri + url;
  },

  getURLWithCDN: function(url) {
    url = this.getURL(url);
    // only relative urls
    if (Nilavu.CDN && /^\/[^\/]/.test(url)) {
      url = Nilavu.CDN + url;
    } else if (Nilavu.S3CDN) {
      url = url.replace(Nilavu.S3BaseUrl, Nilavu.S3CDN);
    }
    return url;
  },

  Resolver: NilavuResolver,

  _titleChanged: function() {
    var title = this.get('_docTitle') || Nilavu.SiteSettings.title;

    // if we change this we can trigger changes on document.title
    // only set if changed.
    if($('title').text() !== title) {
      $('title').text(title);
    }

    var notifyCount = this.get('notifyCount');
    if (notifyCount > 0 && !Nilavu.User.currentProp('dynamic_favicon')) {
      title = "(" + notifyCount + ") " + title;
    }

    document.title = title;
  }.observes('_docTitle', 'hasFocus', 'notifyCount'),

  faviconChanged: function() {
    if(Nilavu.User.currentProp('dynamic_favicon')) {
      var url = Nilavu.SiteSettings.favicon_url;
      if (/^http/.test(url)) {
        url = Nilavu.getURL("/favicon/proxied?" + encodeURIComponent(url));
      }
      new Favcount(url).set(
        this.get('notifyCount')
      );
    }
  }.observes('notifyCount'),

  // The classes of buttons to show on a post
  postButtons: function() {
    return Nilavu.SiteSettings.post_menu.split("|").map(function(i) {
      return i.replace(/\+/, '').capitalize();
    });
  }.property(),

  notifyTitle: function(count) {
    this.set('notifyCount', count);
  },

  notifyBackgroundCountIncrement: function() {
    if (!this.get('hasFocus')) {
      this.set('backgroundNotify', true);
      this.set('notifyCount', (this.get('notifyCount') || 0) + 1);
    }
  },

  resetBackgroundNotifyCount: function() {
    if (this.get('hasFocus') && this.get('backgroundNotify')) {
      this.set('notifyCount', 0);
    }
    this.set('backgroundNotify', false);
  }.observes('hasFocus'),

  authenticationComplete: function(options) {
    // TODO, how to dispatch this to the controller without the container?
    var loginController = Nilavu.__container__.lookup('controller:login');
    return loginController.authenticationComplete(options);
  },

  /**
    Start up the Nilavu application by running all the initializers we've defined.

    @method start
  **/
  start: function() {
    console.log("--- Nilevu ...");
    console.log(Ember.keys(Ember.TEMPLATES));


    $('noscript').remove();

    Ember.keys(requirejs._eak_seen).forEach(function(key) {
      if (/\/pre\-initializers\//.test(key)) {
        var module = require(key, null, null, true);
        if (!module) { throw new Error(key + ' must export an initializer.'); }
        Nilavu.initializer(module.default);
      }
    });

    Ember.keys(requirejs._eak_seen).forEach(function(key) {
      if (/\/initializers\//.test(key)) {
        var module = require(key, null, null, true);
        if (!module) { throw new Error(key + ' must export an initializer.'); }

        var init = module.default;
        var oldInitialize = init.initialize;
        init.initialize = function(app) {
          oldInitialize.call(this, app.container, Nilavu);
        };

        Nilavu.instanceInitializer(init);
      }
    });

  },

  requiresRefresh: function(){
    var desired = Nilavu.get("desiredAssetVersion");
    return desired && Nilavu.get("currentAssetVersion") !== desired;
  }.property("currentAssetVersion", "desiredAssetVersion"),


  assetVersion: Ember.computed({
    get: function() {
      return this.get("currentAssetVersion");
    },
    set: function(key, val) {
      if(val) {
        if (this.get("currentAssetVersion")) {
          this.set("desiredAssetVersion", val);
        } else {
          this.set("currentAssetVersion", val);
        }
      }
      return this.get("currentAssetVersion");
    }
  })
});

function RemovedObject(name) {
  this._removedName = name;
}

function methodMissing() {
  console.warn("The " + this._removedName + " object has been removed from Nilavu " +
               "and your plugin needs to be updated.");
};

Nilavu.RemovedObject = RemovedObject;

['reopen', 'registerButton', 'on', 'off'].forEach(function(m) { RemovedObject.prototype[m] = methodMissing; });
