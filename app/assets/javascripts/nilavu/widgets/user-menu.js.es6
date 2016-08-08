import { createWidget } from 'nilavu/widgets/widget';
import { h } from 'virtual-dom';

createWidget('user-menu-links', {
  tagName: 'div.menu-links-header',

  html(attrs) {
    const { currentUser } = this;

    const path = attrs.path;

    const profileLink = {
      route: 'user',
      model: currentUser,
      className: 'user-profile-link',
      icon: 'user',
      rawLabel: I18n.t('user.profile')
    };

    const links = [profileLink];

    const glyphs = [];

    /*
    TO-DO:  we will user these two glyphs

    const glyphs = [{ label: 'user.favourites',
                      className: 'user-favourites-link',
                      icon: 'bookmark',
                      href: `${path}favourites`}];


    // preferences always goes last
    glyphs.push({ label: 'user.settings',
                  className: 'user-settings-link',
                  icon: 'cog',
                  href: `${path}settings`});
    */
    return h('ul.menu-links-row', [
             links.map(l => h('li', this.attach('link', l))),
             h('li.glyphs.disabled', glyphs.map(l => this.attach('link', $.extend(l, { hideLabel: true })))),
            ]);
  }
});

export default createWidget('user-menu', {
  tagName: 'div.user-menu',

  panelContents() {
    const path = this.currentUser.get('path');

    return [this.attach('user-menu-links', { path }),
            h('div.logout-link', [
              h('hr'),
              h('ul.menu-links',
                h('li', this.attach('link', { action: 'logout',
                                                       className: 'logout',
                                                       icon: 'glyphicon glyphicon-off',
                                                       label: 'user.log_out',
                                                     route:'logout',
                                                 })))
              ])];
  },

  html() {
    return this.attach('menu-panel', { contents: () => this.panelContents() });
  },

  clickOutside() {
    this.sendWidgetAction('toggleUserMenu');
  }
});
