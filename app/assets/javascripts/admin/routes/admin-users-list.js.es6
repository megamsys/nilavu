import { exportEntity } from 'nilavu/lib/export-csv';
import { outputExportResult } from 'nilavu/lib/export-result';
import AdminUser from 'admin/models/admin-user';

export default Nilavu.Route.extend({

  actions: {
    exportUsers() {
      exportEntity('user_list', {trust_level: this.controllerFor('admin-users-list-show').get('query')}).then(outputExportResult);
    },

    sendInvites() {
      this.transitionTo('userInvited', Nilavu.User.current());
    },

    deleteUser(user) {
      AdminUser.create(user).destroy({ deletePosts: true });
    }
  }

});
