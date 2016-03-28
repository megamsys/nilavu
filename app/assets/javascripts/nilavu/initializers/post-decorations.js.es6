import highlightSyntax from 'nilavu/lib/highlight-syntax';
import lightbox from 'nilavu/lib/lightbox';
import { withPluginApi } from 'nilavu/lib/plugin-api';

export default {
  name: "post-decorations",
  initialize() {
    withPluginApi('0.1', api => {
      api.decorateCooked(highlightSyntax);
      api.decorateCooked(lightbox);
    });
  }
};
