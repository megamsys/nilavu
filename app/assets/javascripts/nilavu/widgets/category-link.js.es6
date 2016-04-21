import RawHtml from 'nilavu/widgets/raw-html';
import { categoryBadgeHTML } from 'nilavu/helpers/category-link';

// Right now it's RawHTML. Eventually it should emit nodes
export default class CategoryLink extends RawHtml {
  constructor(attrs) {
    attrs.html = categoryBadgeHTML(attrs.category, attrs);
    super(attrs);
  }
};
