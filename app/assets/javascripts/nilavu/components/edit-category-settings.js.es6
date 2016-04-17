import { setting } from 'nilavu/lib/computed';
import { buildCategoryPanel } from 'nilavu/components/edit-category-panel';

export default buildCategoryPanel('settings', {
  emailInEnabled: setting('email_in'),
  showPositionInput: setting('fixed_category_positions'),
});
