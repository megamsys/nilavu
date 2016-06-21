import { createWidget } from 'nilavu/widgets/widget';
import { iconNode } from 'nilavu/helpers/fa-icon';
import NilavuURL from 'nilavu/lib/url';
import { wantsNewWindow } from 'nilavu/lib/intercept-click';

import { h } from 'virtual-dom';

const dropdown = {
    buildClasses(attrs) {
        if (attrs.active) {
            return "active";
        }
    },

    click(e) {
        if (wantsNewWindow(e)) {
            return;
        }
        e.preventDefault();
        if (!this.attrs.active) {
          if (this.attrs.resource) {
              NilavuURL.routeTo(this.attrs.resource);
          }
          if (this.attrs.action) {
              this.sendWidgetAction(this.attrs.action);
          }
        }
    }
};

createWidget('header-notifications', {
    html(attrs) {
        const {
            currentUser
        } = this;
        const contents = [];

        const unreadNotifications = currentUser.get('unread_notifications');
        if (!!unreadNotifications) {
            contents.push(this.attach('link', {
                action: attrs.action,
                className: 'badge-notification unread-notifications',
                rawLabel: unreadNotifications
            }));
        }

        return contents;
    }
});

createWidget('user-dropdown', jQuery.extend({
    tagName: 'li.header-dropdown-toggle.current-user',

    buildId() {
        return 'current-user';
    },

    html(attrs) {
        const {
            currentUser
        } = this;

        return h('a.c_glob.header_user_profile', {
                attributes: {
                    href: currentUser.get('path'),
                    'data-auto-route': true
                }
            },
            this.attach('header-notifications', attrs));
    }
}, dropdown));

createWidget('header-link', jQuery.extend({
    tagName: 'li',

    html(attrs) {
        const title = I18n.t(attrs.title);

        const body = [iconNode(attrs.icon, {
            hclasz: attrs.icon,
            class: attrs.align
        })];

        if (attrs.contents) {
            body.push(attrs.contents.call(this));
        }

        if (attrs.align) {
            const align = attrs.align ? '.' + attrs.align : '';
            body.push(h('span.hidden-xs.hidden-sm' + align, I18n.t(attrs.title)));
        }

        return h('a', {
            attributes: {
                href: attrs.resource,
                'data-auto-route': true,
                title,
                'aria-label': title,
                id: attrs.iconId
            }
        }, body);
    }
}, dropdown));

createWidget('header-icons', {
    tagName: 'ul.nav.navbar-nav.pull-right',

    buildAttributes() {
        return {
            role: 'navigation'
        };
    },

    html(attrs) {
        const marketplaces = this.attach('header-link', {
            title: 'marketplaces.title',
            align: 'pull-left',
            icon: 'c_icon-window-lg',
            iconId: 'marketplace-button',
            active: attrs.marketplacesVisible,
            resource: 'marketplaces'
        });


        const storages = this.attach('header-link', {
            title: 'storages.title',
            align: 'pull-left',
            icon: 'c_icon-storages-lg',
            iconId: 'toggle-storages-menu',
            active: attrs.storageVisible,
            resource: 'storages'
        });



        const icons = [marketplaces, storages];

        if (this.currentUser) {
            icons.push(this.attach('user-dropdown', {
                active: attrs.userVisible,
                icon: 'user',
                action: 'toggleUserMenu'
            }));
        }

        return icons;
    },
});

export default createWidget('header', {
    tagName: 'div.header.navbar.navbar-fixed-top',
    buildKey: () => `header`,

    defaultState() {
        return {
            marketplacesVisible: true,
            storagesVisible: true,
            userVisible: true,
            contextEnabled: false
        };
    },

    html(attrs, state) {

        const panels = [this.attach('header-icons', {
            marketplacesVisible: state.marketplacesVisible,
            storagesVisible: state.storagesVisible,
            userVisible: state.userVisible,
            flagCount: attrs.flagCount
        })];

        if (state.userVisible) {
            panels.push(this.attach('user-menu'));
        }

        const contents = [this.attach('home-logo', {
                minimized: !!attrs.topic
            }),
            h('div.col-lg-4.col-md-6.col-sm-4.col-xs-6.col-lg-offset-6.col-md-offset-6.col-sm-offset-6', h('div.row', panels))
        ];

        return h('div.container-fluid', h('div.header-inner', h('div.row', contents)));
    },

    closeAll() {
        this.state.userVisible = true;
        this.state.marketplacesVisible = true;
        this.state.storagesVisible = true;
    },

    linkClickedEvent() {
        this.closeAll();
    },

    toggleUserMenu() {
        this.state.userVisible = !this.state.userVisible;
    },

    domClean() {
        const {
            state
        } = this;

        if (state.userVisible) {
            this.closeAll();
        }
    },

    headerKeyboardTrigger(msg) {
        switch (msg.type) {
            case 'user':
                this.toggleUserMenu();
                break;
        }
    }

});
