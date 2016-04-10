import StringBuffer from 'nilavu/mixins/string-buffer';

export default Ember.Component.extend(StringBuffer, {
  classNameBindings: ['hidden'],
  rerenderTriggers: ['text', 'longDescription'],

  _bindClick: function() {
    // If there's a click handler, call it
    if (this.clicked) {
      const self = this;
      this.$().on('click.dropdown-button', 'ul li', function(e) {
        e.preventDefault();
        if ($(e.currentTarget).data('id') !== self.get('activeItem')) {
          self.clicked($(e.currentTarget).data('id'));
        }
        alert("--- clicked drop");
        self.$('.dropdown-toggle').dropdown('toggle');
        return false;
      });
    }
  }.on('didInsertElement'),



  _unbindClick: function() {
    this.$().off('click.dropdown-button', 'ul li');
  }.on('willDestroyElement'),

  renderString(buffer) {
    const title = this.get('title');
    buffer.push(`<a href='#' class='btn btn-success dropdown-toggle ${this.get('buttonExtraClasses')}'>`);
    buffer.push("<span class='caret'></span>");
    buffer.push(`<b>${this.get('text')}</b>`);
    buffer.push("</a>");

    buffer.push("<ul class='toponeclick_left_add_inner'>");

    const contents = this.get('dropDownContent');
    if (contents) {
      const self = this;
      contents.forEach(function(row) {
        const id = row.id,
              className = (self.get('activeItem') === id ? 'disabled': '');

        buffer.push("<li data-id=\"" + id + "\" class=\"" + className + "\"><a href>");
        buffer.push("<i class='" + row.styleClasses + "'></i>");
        buffer.push(row.title);
        buffer.push("</a></li>");
      });
    }


    buffer.push("</ul>");

  }
});
