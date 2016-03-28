import { iconHTML } from 'nilavu/helpers/fa-icon';

export default Em.Component.extend({
  tagName: 'h3',

  render(buffer) {
    const category = this.get('category');
    const categoryUrl = Nilavu.getURL('/c/') + Nilavu.Category.slugFor(category);
    const categoryName = Handlebars.Utils.escapeExpression(category.get('name'));

    if (category.get('read_restricted')) { buffer.push(iconHTML('lock')); }

    buffer.push(`<a href='${categoryUrl}'>`);
    buffer.push(`<span class='category-name'>${categoryName}</span>`);
    buffer.push(`</a>`);
  }
});
