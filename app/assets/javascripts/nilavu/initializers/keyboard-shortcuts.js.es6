/*global Mousetrap:true*/
import KeyboardShortcuts from 'nilavu/lib/keyboard-shortcuts';

export default {
  name: "keyboard-shortcuts",

  initialize(container) {
    KeyboardShortcuts.bindEvents(Mousetrap, container);
  }
};
