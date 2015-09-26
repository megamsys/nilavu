  // grid/list
  $('#app-list').hide();

  $('#app-list-btn').on('click', function() {
    $('#app-grid').hide();
    $('#app-list').show();

  });

  $('#app-grid-btn').on('click', function() {
    $('#app-list').hide();
    $('#app-grid').show();

  });

  $(window).on('resize', function() {
    if ($(window).width() < 480) {
      $('#app-list').hide();
      $('#app-grid').show();
    };
  });

  $('#marketplace_top_right').on('hover', function() {
    $('#marketplace_top_right i').toggleClass('c_icon-window-lg');
    $('#marketplace_top_right i').toggleClass('c_icon-window-lg-sel');
    $('#marketplace_top_right span').toggleClass('mplace-selected');
  });
  $('#storage_top_right').on('hover', function() {
    $('#storage_top_right i').toggleClass('c_icon-grid-hover');
    $('#storage_top_right i').toggleClass('c_icon-grid-25');
    // $('#stor i').toggleClass('c_icon-grid');
    $('#storage_top_right span').toggleClass('mplace-selected');
  });
