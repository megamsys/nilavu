const SSHOptionType = Nilavu.Model.extend({
  description: function(){
    var key = "";
    switch(this.get("id")){
      case 1:
        key = "old";
        break;
      case 2:
        key = "create";
        break;
      case 3:
        key = "import";
        break;
    }
    return I18n.t("launcher.sshoption_" + key);
  }
});

SSHOptionType.OLD = 1;
SSHOptionType.CREATE = 2;
SSHOptionType.IMPORT = 3;

export default SSHOptionType;
