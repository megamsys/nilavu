import RawHtml from 'nilavu/widgets/raw-html';
import { createWidget } from 'nilavu/widgets/widget';
import { h } from 'virtual-dom';
import { iconNode } from 'nilavu/helpers/fa-icon';
import NilavuURL from 'nilavu/lib/url';

createWidget('post-link-arrow', {
  html(attrs) {
   if (attrs.above) {
     return h('a.post-info.arrow', {
       attributes: { title: I18n.t('topic.jump_reply_up') }
     }, iconNode('arrow-up'));
   } else {
     return h('a.post-info.arrow', {
       attributes: { title: I18n.t('topic.jump_reply_down') }
     }, iconNode('arrow-down'));
   }
  },

  click() {
    NilavuURL.routeTo(this.attrs.shareUrl);
  }
});

export default createWidget('embedded-post', {
  buildKey: attrs => `embedded-post-${attrs.id}`,

  html(attrs, state) {
    return [
      h('div.row', [
        this.attach('post-avatar', attrs),
        h('div.topic-body', [
          h('div.topic-meta-data', [
            this.attach('poster-name', attrs),
            this.attach('post-link-arrow', { above: state.above, shareUrl: attrs.shareUrl })
          ]),
          new RawHtml({html: `<div class='cooked'>${attrs.cooked}</div>`})
        ])
      ])
    ];
  }
});
