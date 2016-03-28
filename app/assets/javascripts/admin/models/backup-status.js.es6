import computed from "ember-addons/ember-computed-decorators";

export default Nilavu.Model.extend({

  restoreDisabled: Em.computed.not("restoreEnabled"),

  @computed("allowRestore", "isOperationRunning")
  restoreEnabled(allowRestore, isOperationRunning) {
    return allowRestore && !isOperationRunning;
  }

});
