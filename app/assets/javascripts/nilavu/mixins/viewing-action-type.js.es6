export default {
  viewingActionType(userActionType) {
    this.controllerFor('user').set('userActionType', userActionType);
  }

};
