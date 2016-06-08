const LogCategoryPanel = Ember.Component.extend({
  classNameBindings: [':modal-tab', 'activeTab::invisible'],
});

export default LogCategoryPanel;

export function logCategoryPanel(tab, extras) {
  return LogCategoryPanel.extend({
    activeTab: Ember.computed.equal('logSelectedTab', tab)
  }, extras || {});
}
