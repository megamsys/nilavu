  // Instance the tour
var tour = new Tour({
  steps: [
  {
    element: ".one",
    title: "<i class='fa fa-soundcloud'></i> Step 1",
    content: "Click to see all our apps and services !!"
  },
      {
    element: ".two",
    title: "<i class='fa fa-soundcloud'></i> Step 2",
    content: "Click to see all our apps and services !!"
  }  
],
  backdrop: true,
  storage: false
});

tour.init();

tour.start();
