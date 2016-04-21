import loadScript from 'nilavu/lib/load-script';

//  Use the message bus for live reloading of components for faster development.
export default {
  name: "live-development",
  initialize(container) {

    // subscribe to any site customizations that are loaded
    $('link.custom-css').each(function() {
      const split = this.href.split("/"),
          id = split[split.length - 1].split(".css")[0],
          self = this;

    });

    // Custom header changes
    $('header.custom').each(function() {
      const header = $(this);
    });

  }
};
