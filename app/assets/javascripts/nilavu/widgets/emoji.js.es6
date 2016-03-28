import { createWidget } from 'nilavu/widgets/widget';

export default createWidget('emoji', {
  tagName: 'img.emoji',

  buildAttributes(attrs) {
    return { src: Nilavu.Emoji.urlFor(attrs.name) };
  },
});
