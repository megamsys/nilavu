app.factory("MetricsHelper", function() { 

  function getTarget(m_type) {
    var metric = null;
    switch(m_type) {
      case "cpu":
        metric = "cpu_system";
        break;
      case "http requests":
        metric = "nginx_requests";
        break;      
      default:
        metric = "cpu_system";
    }
    return metric;
  }  

  return {
    getTarget: getTarget    
  };
});