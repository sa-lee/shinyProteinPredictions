// override the default options with something less restrictive.

var options = {
  width: 500,
  height: 500,
  antialias: true,
};

function superimpose(message, viewer) {

  var files = message.split(";");
  var query = files[0];
  var subject = files[1];

  var queryv = pv.io.fetchPdb(query, function(structure) {
  	viewer.cartoon('prediction', structure, { color: color.uniform('#67a9cf') });
  	viewer.centerOn(structure);
  	viewer.fitTo(structure);
  	
  });

  var subjectv = pv.io.fetchPdb(subject, function(structure) {
  	viewer.trace('real', structure, { color: color.uniform('#ef8a62') });
  	viewer.centerOn(structure);
  	viewer.fitTo(structure);
  });
  
  viewer.autoZoom();

}

$(document).ready(function() {
  Shiny.addCustomMessageHandler("myCallbackHandler", 
  function(message) {
    var parent = document.getElementById('gl');
    // insert the viewer under the Dom element with id 'gl'.
    var viewer = pv.Viewer(parent, options);
    document.addEventListener('DOMContentLoaded', superimpose(message, viewer));
  }
);
})



