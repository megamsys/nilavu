export default {
  resource: 'admin',

  map() {
    this.route('dashboard', { path: '/' });

    this.resource('adminSiteSettings', { path: '/site_settings' }, function() {
      this.resource('adminSiteSettingsCategory', { path: 'category/:category_id'} );
    });

    this.resource('adminReports', { path: '/reports/:type' });

    this.resource('adminUsers', { path: '/users' }, function() {
      this.resource('adminUser', { path: '/:user_id/:username' }, function() {
        this.route('badges');
        this.route('tl3Requirements', { path: '/tl3_requirements' });
      });

      this.resource('adminUsersList', { path: '/list' }, function() {
        this.route('show', { path: '/:filter' });
      });
    });
  }
};
