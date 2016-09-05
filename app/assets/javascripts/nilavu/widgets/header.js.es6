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

createWidget('user-dropdown', jQuery.extend({
    tagName: 'li.navbar-item.header-dropdown-toggle.current-user',

    buildId() {
        return 'current-user';
    },

    html(attrs) {
        const { currentUser } = this;

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

createWidget('header-navbar-add', {
    tagName: 'li',
    html(attrs) {
        return h('codrops-icon.codrops-icon-prev.add-new', h('span.glyphicon.glyphicon-plus'));
    },
});

createWidget('header-navbar-links', {
    tagName: 'li.gn-trigger',
    html(attrs) {
        const dashboard = this.attach('header-link', {
            title: 'dashboards.title',
            align: 'pull-left',
            icon: 'leftnav_dashboard',
            iconId: 'dashboard-button',
            resource: 'dashboard'
        });

        const machines = this.attach('header-link', {
            title: 'dashboards.machine',
            align: 'pull-left',
            icon: 'leftnav_torpedo',
            iconId: 'torpedo-button',
            resource: 'torpedo'
        });
        
        const apps = this.attach('header-link', {
            title: 'dashboards.apps',
            align: 'pull-left',
            icon: 'leftnav_app',
            iconId: 'app-button',
            resource: 'app'
        });
        
        const services = this.attach('header-link', {
            title: 'dashboards.services',
            align: 'pull-left',
            icon: 'leftnav_service',
            iconId: 'service-button',
            resource: 'service'
        });
        
        const microservices = this.attach('header-link', {
            title: 'dashboards.micro',
            align: 'pull-left',
            icon: 'leftnav_microservice',
            iconId: 'microservice-button',
            resource: 'microservice'
        });
        
        const sshkeys = this.attach('header-link', {
            title: 'dashboards.sshkeys',
            align: 'pull-left',
            icon: 'leftnav_settings',
            iconId: 'sshkeys-button',
            resource: 'sshkeys'
        });

        const links = [dashboard, machines, apps, services, microservices, sshkeys];
        
        const gnMenuTrigger = this.attach('gn-menu-trigger');
        const gnMenuWrapper = h('nav.gn-menu-wrapper', h('div.gn-scroller', h('ul.gn-menu', links)));
        const gnMenuContent = [gnMenuTrigger, gnMenuWrapper];
        return gnMenuContent;
    },
});

createWidget('gn-menu-trigger', {
    tagName: 'a.gn-icon.gn-icon-menu',
    html() {
        return h('span', "menu");
    },
});

createWidget('header-icons', {
    tagName: 'ul.nav.navbar-nav.pull-right.xs-centerBlock-m',

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
            resource: 'marketplaces'
        });


        const storages = this.attach('header-link', {
            title: 'storages.title',
            align: 'pull-left',
            icon: 'c_icon-storages-lg',
            iconId: 'toggle-storages-menu',
            resource: 'storages'
        });

        const icons = [marketplaces, storages];

        if (this.currentUser) {
            icons.push(this.attach('user-dropdown', {
                active: attrs.eventsVisible,
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
    },
});

export default createWidget('header', {
    tagName: 'ul.header.navbar.navbar-fixed-top.gn-menu-main.no-touch#gn-menu',
    buildKey: () => `header`,

    defaultState() {
        return {
            marketplacesVisible: true,
            storagesVisible: true,
            userVisible: false,
            eventsVisible: false,
            contextEnabled: false
        };
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
        const navbar = [
            this.attach('header-navbar-links'),
            this.attach('header-navbar-add')
        ];
        
        const homeLogo = this.attach('home-logo', {
            minimized: !!attrs.topic
        });
        const navLinks = h('div.col-lg-6.col-sm-8.col-xs-12.navbar-layout.pull-right', h('div.row', panels));
        const content = [homeLogo, navLinks]; //The logo & right navlinks.
        const innerContents = h('div.container', h('div.header-inner', content)); //We wrap the innerContents (logo/navlinks) inside a container
        const contents = [navbar, innerContents]; //the NavBar trigger is outside the container, so we wrap it side by side the innerContents.
        
        return contents;
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
            case 'events':
                this.toggleEventsMenu();
                break;
        }
    }

});
