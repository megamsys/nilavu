import ButtonView from 'nilavu/views/button';
import { iconHTML } from 'nilavu/helpers/fa-icon';

export default ButtonView.extend({
  classNames: ['flag-topic'],
  textKey: 'topic.flag_topic.title',
  helpKey: 'topic.flag_topic.help',

  click() {
    this.get('controller').send('showFlagTopic', this.get('controller.content'));
  },

  renderIcon(buffer) {
    buffer.push(iconHTML('flag'));
  }
});
