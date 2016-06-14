import MountWidget from 'nilavu/components/mount-widget';
import { observes } from 'ember-addons/ember-computed-decorators';

const PANEL_BODY_MARGIN = 30;

const PredeployStatusComponent = MountWidget.extend({
  widget: 'predeploy-notifications',

  profileWidget: true,
  // classNameBindings: ['editingTopic'],

  @observes('currentUser.unread_notifications', 'currentUser.unread_private_messages')
  _notificationsChanged() {
    this.queueRerender();
  },

  didInsertElement() {
    this._super();
    $(window).bind('scroll.discourse-dock', () => this.examineDockHeader());
    $(document).bind('touchmove.discourse-dock', () => this.examineDockHeader());
    $(window).on('resize.discourse-menu-panel', () => this.afterRender());

    this.dispatch('notifications:changed', 'predeploy-notifications');

    this.appEvents.on('dom:clean', () => {
      // For performance, only trigger a re-render if any menu panels are visible
      if (this.$('.menu-panel').length) {
        this.eventDispatched('dom:clean', 'header');
      }
    });

  },

  willDestroyElement() {
    this._super();
    $(window).unbind('scroll.discourse-dock');
    $(document).unbind('touchmove.discourse-dock');
    $('body').off('keydown.header');
    this.appEvents.off('notifications:changed');
    $(window).off('resize.discourse-menu-panel');
    this.appEvents.off('dom:clean');
  },

  buildArgs() {
    alert(this.get('id') +"," + this.get('name'));
    return {
      id: this.get('id'),
      name: this.get('name')
    };
  },

  afterRender() {
    const $menuPanels = $('.menu-panel');
    if ($menuPanels.length === 0) { return; }

    const $window = $(window);
    const windowWidth = parseInt($window.width());


    const headerWidth = $('#main-outlet .container').width() || 1100;
    const remaining = parseInt((windowWidth - headerWidth) / 2);
    const viewMode = (remaining < 50) ? 'slide-in' : 'drop-down';

    /*$menuPanels.each((idx, panel) => {
      const $panel = $(panel);
      let width = parseInt($panel.attr('data-max-width') || 300);
      if ((windowWidth - width) < 50) {
        width = windowWidth - 50;
      }

      $panel.removeClass('drop-down').removeClass('slide-in').addClass(viewMode);

      const $panelBody = $('.panel-body', $panel);
      let contentHeight = parseInt($('.panel-body-contents', $panel).height());

      // We use a mutationObserver to check for style changes, so it's important
      // we don't set it if it doesn't change. Same goes for the $panelBody!
      const style = $panel.prop('style');

      if (viewMode === 'drop-down') {
        const $buttonPanel = $('header ul.icons');
        if ($buttonPanel.length === 0) { return; }

        // These values need to be set here, not in the css file - this is to deal with the
        // possibility of the window being resized and the menu changing from .slide-in to .drop-down.
        if (style.top !== '100%' || style.height !== 'auto') {
          $panel.css({ top: '100%', height: 'auto' });
        }

        // adjust panel height
        const fullHeight = parseInt($window.height());
        const offsetTop = $panel.offset().top;
        const scrollTop = $window.scrollTop();

        if (contentHeight + (offsetTop - scrollTop) + PANEL_BODY_MARGIN > fullHeight) {
          contentHeight = fullHeight - (offsetTop - scrollTop) - PANEL_BODY_MARGIN;
        }
        if ($panelBody.height() !== contentHeight) {
          $panelBody.height(contentHeight);
        }
        $('body').addClass('drop-down-visible');
      } else {
        const menuTop = headerHeight();

        let height;
        const winHeight = $(window).height() - 16;
        if ((menuTop + contentHeight) < winHeight) {
          height = contentHeight + "px";
        } else {
          height = winHeight - menuTop;
        }

        if ($panelBody.prop('style').height !== '100%') {
          $panelBody.height('100%');
        }
        if (style.top !== menuTop + "px" || style.height !== height) {
          $panel.css({ top: menuTop + "px", height });
        }
        $('body').removeClass('drop-down-visible');
      }
      $panel.width(width);

    });*/
  }
});

export default PredeployStatusComponent;
