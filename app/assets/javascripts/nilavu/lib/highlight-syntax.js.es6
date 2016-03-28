/*global hljs:true */

import loadScript from 'nilavu/lib/load-script';

export default function highlightSyntax($elem) {
  const selector = Nilavu.SiteSettings.autohighlight_all_code ? 'pre code' : 'pre code[class]',
        path = Nilavu.HighlightJSPath;

  if (!path) { return; }

  $(selector, $elem).each(function(i, e) {
    $(e).removeClass('lang-auto');
    loadScript(path).then(() => hljs.highlightBlock(e));
  });
}
