shinyjs.resetdiv = function() {
  var div = $("<div>", {id: 'gl', style:"width:600px; margin: auto;"});
  $('#gl').replaceWith(div);
  alert("Next protein coming up!");
}