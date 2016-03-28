import ButtonView from 'nilavu/views/button';
import { iconHTML } from 'nilavu/helpers/fa-icon';

export default ButtonView.extend({
  classNames: ['share'],
  textKey: 'topic.share.title',
  helpKey: 'topic.share.help',
  'data-share-url': Em.computed.alias('topic.shareUrl'),
  topic: Em.computed.alias('controller.model'),

  renderIcon(buffer) {
    buffer.push(iconHTML("link"));
  }
});
