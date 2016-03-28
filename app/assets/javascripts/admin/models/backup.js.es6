const Backup = Nilavu.Model.extend({

  destroy() {
    return Nilavu.ajax("/admin/backups/" + this.get("filename"), { type: "DELETE" });
  },

  restore() {
    return Nilavu.ajax("/admin/backups/" + this.get("filename") + "/restore", {
      type: "POST",
      data: { client_id: window.MessageBus.clientId }
    });
  }

});

Backup.reopenClass({

  find() {
    return PreloadStore.getAndRemove("backups", () => Nilavu.ajax("/admin/backups.json"))
                       .then(backups => backups.map(backup => Backup.create(backup)));
  },

  start(withUploads) {
    if (withUploads === undefined) { withUploads = true; }
    return Nilavu.ajax("/admin/backups", {
      type: "POST",
      data: {
        with_uploads: withUploads,
        client_id: window.MessageBus.clientId
      }
    }).then(result => {
      if (!result.success) { bootbox.alert(result.message); }
    });
  },

  cancel() {
    return Nilavu.ajax("/admin/backups/cancel.json")
                    .then(result => {
                      if (!result.success) { bootbox.alert(result.message); }
                    });
  },

  rollback() {
    return Nilavu.ajax("/admin/backups/rollback.json")
                    .then(result => {
      if (!result.success) {
        bootbox.alert(result.message);
      } else {
        // redirect to homepage (session might be lost)
        window.location.pathname = Nilavu.getURL("/");
      }
    });
  }
});

export default Backup;
