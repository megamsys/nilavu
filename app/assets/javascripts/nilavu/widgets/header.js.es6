import {createWidget} from 'nilavu/widgets/widget';
import {iconNode} from 'nilavu/helpers/fa-icon';
import NilavuURL from 'nilavu/lib/url';
import {wantsNewWindow} from 'nilavu/lib/intercept-click';

import {h} from 'virtual-dom';

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

createWidget('user-dropdown', jQuery.extend({
    tagName: 'li.navbar-item.header-dropdown-toggle.current-user',

    buildId() {
        return 'current-user';
    },

    html(attrs) {
        const {currentUser} = this;

        const body = [iconNode(attrs.icon, {
                hclasz: attrs.icon,
                class: attrs.align
            })];

        if (attrs.contents) {
            body.push(attrs.contents.call(this));
        }
        return h('a', {
            attributes: {
                href: currentUser.get('path'),
                'data-auto-route': true
            }
        }, body);
    }
}, dropdown));

createWidget('header-link', jQuery.extend({
    tagName: 'li.navbar-item',

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
            const align = attrs.align
                ? '.' + attrs.align
                : '';
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
    tagName: 'ul.nav.navbar-nav.pull-right.xs-centerBlock-m',

    buildAttributes() {
        return {role: 'navigation'};
    },

    html(attrs) {
        const marketplaces = this.attach('header-link', {
            title: 'marketplaces.title',
            align: 'pull-left',
            icon: 'c_icon-window-lg',
            iconId: 'marketplace-button',
            resource: 'marketplaces'
        });

        const storages = this.attach('header-link', {
            title: 'storages.title',
            align: 'pull-left',
            icon: 'c_icon-storages-lg',
            iconId: 'toggle-storages-menu',
            resource: 'storages'
        });

        const icons = [marketplaces];

        if (Nilavu.SiteSettings.enable_ceph_logins) {
            icons.push(storages);
        }

        if (this.currentUser) {
            icons.push(this.attach('user-dropdown', {
                active: attrs.eventsVisible,
                //TO-DO we enable this glyphicon bell.
                //icon: 'glyphicon glyphicon-bell',
                icon: 'c_glob header_events',
                action: 'toggleEventsMenu'
            }));

            icons.push(this.attach('user-dropdown', {
                active: attrs.userVisible,
                icon: 'c_glob header_user_profile',
                action: 'toggleUserMenu'
            }));
        }

        return icons;
    }
});

export default createWidget('header', {
    tagName: 'div.header.navbar.navbar-fixed-top',
    buildKey: () => `header`,

    defaultState() {
        return {marketplacesVisible: true, storagesVisible: true, userVisible: false, eventsVisible: false, contextEnabled: false};
    },

    html(attrs, state) {

        const panels = [this.attach('header-icons', {
                marketplacesVisible: state.marketplacesVisible,
                storagesVisible: state.storagesVisible,
                userVisible: state.userVisible,
                eventsVisible: state.eventsVisible,
                flagCount: attrs.flagCount
            })];

        if (state.eventsVisible) {
            panels.push(this.attach('events-menu'));
        }

        if (state.userVisible) {
            panels.push(this.attach('user-menu'));
        }

        const contents = [
            this.attach('home-logo', {
                minimized: !!attrs.topic
            }),
            h('div.col-lg-4.col-sm-8.col-xs-12.offset-lg-6.offset-sm-1.offset-md-2.navbar-layout', h('div.row', panels))
        ];

        return h('div.container-fluid', h('div.header-inner', h('div.row', contents)));
    },

    closeAll() {
        this.state.userVisible = false;
        this.state.marketplacesVisible = true;
        this.state.storagesVisible = true;
        this.state.eventsVisible = false;
    },

    linkClickedEvent() {
        this.closeAll();
    },

    toggleUserMenu() {
        this.state.userVisible = !this.state.userVisible;
    },

    toggleEventsMenu() {
        this.state.eventsVisible = !this.state.eventsVisible;
    },

    domClean() {
        const {state} = this;

        if (state.userVisible) {
            this.closeAll();
        }
    },

    headerKeyboardTrigger(msg) {
        switch (msg.type) {
            case 'user':
                this.toggleUserMenu();
                break;
            case 'events':
                this.toggleEventsMenu();
                break;
        }
    }

});
