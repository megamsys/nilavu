Nilavu.RepoMethod = Ember.Object.extend({
  title: function() {
    var titleSetting = this.get('titleSetting');
    if (!Ember.isEmpty(titleSetting)) {
      var result = Nilavu.SiteSettings[titleSetting];
      if (!Ember.isEmpty(result)) { return result; }
    }

    return this.get("titleOverride") || I18n.t("repo." + this.get("name") + ".title");
  }.property(),

  message: function() {
    return this.get("messageOverride") || I18n.t("repo." + this.get("name") + ".message");
  }.property()
});

Nilavu.RepoMethod.reopenClass({
  register: function(method) {
    if (this.methods){
      this.methods.pushObject(method);
    } else {
      this.preRegister = this.preRegister || [];
      this.preRegister.push(method);
    }
  },

  all: function(){
    if (this.methods) { return this.methods; }

    var methods = this.methods = Em.A();

    [ "github"].forEach(function(name){
      if (Nilavu.SiteSettings["enable_" + name + "_logins"]) {

        var params = {name: name};

      /*  if (name === "gitlab") {
          params.frameWidth = 850;
          params.frameHeight = 500;
        } else if (name === "dockerhub") {
          params.frameHeight = 450;
        }
        */

        methods.pushObject(Nilavu.RepoMethod.create(params));
      }
    });

    if (this.preRegister){
      this.preRegister.forEach(function(method){
        var enabledSetting = method.get('enabledSetting');
        if (enabledSetting) {
          if (Nilavu.SiteSettings[enabledSetting]) {
            methods.pushObject(method);
          }
        } else {
          methods.pushObject(method);
        }
      });
      delete this.preRegister;
    }
    return methods;
  }.property()
});
