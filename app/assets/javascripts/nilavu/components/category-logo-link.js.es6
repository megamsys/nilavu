export default Em.Component.extend({
  tagName: 'a',
  attributeBindings: ['href'],
  href: function() {
    return Nilavu.getURL('/c/') + Nilavu.Category.slugFor(this.get('category'));
  }.property(),

  render(buffer) {
    const categoryLogo = this.get('category.logo_url');
    buffer.push(`<img class="category-logo" src='${categoryLogo}'/>`);
  }
});