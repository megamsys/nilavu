const LogCategoryPanel = Ember.Component.extend({
  tagName: 'ul',
  classNameBindings: [':modal-tab-log', 'activeTab::invisible', ':ui-listview'],
});

export default LogCategoryPanel;

export function logCategoryPanel(tab, extras) {
  return LogCategoryPanel.extend({
    activeTab: Ember.computed.equal('logSelectedTab', tab)
  }, extras || {});
}
