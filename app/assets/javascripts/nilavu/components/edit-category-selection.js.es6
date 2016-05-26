import { buildCategoryPanel } from 'nilavu/components/edit-category-panel';
import PermissionType from 'nilavu/models/permission-type';

export default buildCategoryPanel('selection', {
  editingPermissions: false,
  selectedGroup: null,
  selectedPermission: null,


  isVirtualMachine: function() {
      const launchable = this.get('launchOption') || "";
      return (launchable.trim.length > 0 && Ember.isEqual(launchable.trim(), I18n.t('launcher.virtualmachines')));
  }.observes('category.launchoption'),

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
