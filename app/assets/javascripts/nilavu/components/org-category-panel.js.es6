const OrgCategoryPanel = Ember.Component.extend({
  classNameBindings: [':modal-tab', 'activeTab::invisible'],
});

export default OrgCategoryPanel;

export function orgCategoryPanel(tab, extras) {
  return OrgCategoryPanel.extend({
    activeTab: Ember.computed.equal('orgSelectedTab', tab)
  }, extras || {});
}
