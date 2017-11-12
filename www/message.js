// override the default options with something less restrictive.

var options = {
  width: 500,
  height: 500,
  antialias: true,
};
// insert the viewer under the Dom element with id 'gl'.
var viewer = pv.Viewer(document.getElementById('gl'), options);

function superimpose(message) {
  // asynchronously load the PDB file for the
  // from the server and display it in the viewer.
  // var query = 'db/PF3D7_0608310_model1.pdb';
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

Shiny.addCustomMessageHandler("myCallbackHandler", 
  function(message) {
    document.addEventListener('DOMContentLoaded', superimpose(message));
  }
);