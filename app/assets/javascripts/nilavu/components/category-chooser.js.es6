import ComboboxView from 'nilavu/components/combo-box';
import { categoryBadgeHTML } from 'nilavu/helpers/category-link';
import computed from 'ember-addons/ember-computed-decorators';
import { observes, on } from 'ember-addons/ember-computed-decorators';
import PermissionType from 'nilavu/models/permission-type';

export default ComboboxView.extend({
  classNames: ['combobox category-combobox'],
  dataAttributes: ['id', 'description_text'],
  valueBinding: Ember.Binding.oneWay('source'),
  overrideWidths: true,
  castInteger: true,

  @computed("scopedCategoryId", "categories")
  content(scopedCategoryId, categories) {
    // Always scope to the parent of a category, if present
    if (scopedCategoryId) {
      const scopedCat = Nilavu.Category.findById(scopedCategoryId);
      scopedCategoryId = scopedCat.get('parent_category_id') || scopedCat.get('id');
    }

    return categories.filter(c => {
      if (scopedCategoryId && c.get('id') !== scopedCategoryId && c.get('parent_category_id') !== scopedCategoryId) { return false; }
      if (c.get('isUncategorizedCategory')) { return false; }
      return c.get('permission') === PermissionType.FULL;
    });
  },

  @on("init")
  @observes("site.sortedCategories")
  _updateCategories() {
    if (!this.get('categories')) {
      const categories = Nilavu.SiteSettings.fixed_category_positions_on_create ?
                           Nilavu.Category.list() :
                           Nilavu.Category.listByActivity();
      this.set('categories', categories);
    }
  },

  @computed("rootNone")
  none(rootNone) {
    if (Nilavu.SiteSettings.allow_uncategorized_topics) {
      if (rootNone) {
        return "category.none";
      } else {
        return Nilavu.Category.findUncategorized();
      }
    } else {
      return 'category.choose';
    }
  },

  comboTemplate(item) {
    let category;

    // If we have no id, but text with the uncategorized name, we can use that badge.
    if (Ember.isEmpty(item.id)) {
      const uncat = Nilavu.Category.findUncategorized();
      if (uncat && uncat.get('name') === item.text) {
        category = uncat;
      }
    } else {
      category = Nilavu.Category.findById(parseInt(item.id,10));
    }

    if (!category) return item.text;
    let result = categoryBadgeHTML(category, {link: false, allowUncategorized: true, hideParent: true});
    const parentCategoryId = category.get('parent_category_id');

    if (parentCategoryId) {
      result = categoryBadgeHTML(Nilavu.Category.findById(parentCategoryId), {link: false}) + "&nbsp;" + result;
    }

    result += ` <span class='topic-count'>&times; ${category.get('topic_count')}</span>`;

    const description = category.get('description');
    // TODO wtf how can this be null?;
    if (description && description !== 'null') {
      result += `<div class="category-desc">${description.substr(0, 200)}${description.length > 200 ? '&hellip;' : ''}</div>`;
    }

    return result;
  }

});
