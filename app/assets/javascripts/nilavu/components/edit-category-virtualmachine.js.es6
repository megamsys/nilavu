import { buildCategoryPanel } from 'nilavu/components/edit-category-panel';
import PermissionType from 'nilavu/models/permission-type';

export default buildCategoryPanel('virtualmachine', {
  editingPermissions: false,
  selectedGroup: null,
  selectedPermission: null,

  actions: {
    editPermissions() {
      if (!this.get('category.is_special')) {
        this.set('editingPermissions', true);
      }
    },

    addPermission(group, id) {
      if (!this.get('category.is_special')) {
        this.get('category').addPermission({
          group_name: group + "",
          permission: PermissionType.create({id})
        });
      }
    },

    removePermission(permission) {
      if (!this.get('category.is_special')) {
        this.get('category').removePermission(permission);
      }
    },
  }
});
