import { categoryLinkHTML } from 'nilavu/helpers/category-link';
import registerUnbound from 'nilavu/helpers/register-unbound';

registerUnbound('category-badge', function(cat, options) {
  options.link = false;
  return categoryLinkHTML(cat, options);
});
