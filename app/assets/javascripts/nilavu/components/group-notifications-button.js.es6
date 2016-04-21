import NotificationsButton from 'nilavu/components/notifications-button';

export default NotificationsButton.extend({
  classNames: ['notification-options', 'group-notification-menu'],
  notificationLevel: Em.computed.alias('group.notification_level'),
  i18nPrefix: 'groups.notifications',

  clicked(id) {
    this.get('group').setNotification(id);
  }
});
