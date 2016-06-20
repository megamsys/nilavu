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
        key = "pwd";
        break;
      case 4:
        key = "import";
        break;
    }
    return I18n.t("launcher.sshoption_" + key);
  }
});

SSHOptionType.OLD = 1;
SSHOptionType.CREATE = 2;
SSHOptionType.PWD = 3;
SSHOptionType.IMPORT = 4;

export default SSHOptionType;
