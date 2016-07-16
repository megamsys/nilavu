import { createWidget } from 'nilavu/widgets/widget';
import { h } from 'virtual-dom';


export default createWidget('events-menu', {
  tagName: 'div.events-menu',

  panelContents() {
    const path = this.currentUser.get('path');

    return [this.attach('events-notifications', { path })];
  },

  html() {
    return this.attach('menu-panel', { contents: () => this.panelContents() });
  },

  clickOutside() {
    this.sendWidgetAction('toggleEventsMenu');
  }
});
