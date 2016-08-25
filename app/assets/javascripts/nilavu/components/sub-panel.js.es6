const SubPanel = Ember.Component.extend({
  classNameBindings: [':modal-tab', 'activeTab::invisible'],
});

export default SubPanel;

export function buildSubPanel(tab, extras) {
  return SubPanel.extend({
    activeTab: Ember.computed.equal('selectedTab', tab)
  }, extras || {});
}
