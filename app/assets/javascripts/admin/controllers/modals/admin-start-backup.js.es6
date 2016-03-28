import ModalFunctionality from 'nilavu/mixins/modal-functionality';
import Backup from 'admin/models/backup';

export default Ember.Controller.extend(ModalFunctionality, {
  needs: ["adminBackupsLogs"],

  _startBackup: function (withUploads) {
    var self = this;
    Nilavu.User.currentProp("hideReadOnlyAlert", true);
    Backup.start(withUploads).then(function() {
      self.get("controllers.adminBackupsLogs").clear();
      self.send("backupStarted");
    });
  },

  actions: {

    startBackup: function () {
      this._startBackup();
    },

    startBackupWithoutUpload: function () {
      this._startBackup(false);
    },

    cancel: function () {
      this.send("closeModal");
    }

  }

});
