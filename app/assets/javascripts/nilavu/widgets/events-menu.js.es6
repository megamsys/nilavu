import { createWidget } from 'nilavu/widgets/widget';
import { h } from 'virtual-dom';


export default createWidget('events-menu', {
  tagName: 'div.events-menu',

  panelContents() {
    const path = '/user/'+ this.currentUser.email;

    return [this.attach('events-notifications', { path })];
  },

  html() {
    return this.attach('menu-panel', { contents: () => this.panelContents() });
  },

  clickOutside() {
    this.sendWidgetAction('toggleEventsMenu');
  }
});
