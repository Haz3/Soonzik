$(document).ready(function() {
  var dispatcher = new WebSocketRails('lvh.me:3000/websocket');

  $("#sendMessage").on("click", function() {
    if ($("#message").val() != "") {
      dispatcher.trigger('messages.send', { data: $("#message").val(), to: 2 })
      $("#message").val("");
    }
  });

  dispatcher.bind('new_message', function(data) {
    $("#container_msg").append("<p>" + (data.from != null ? "<strong>" + data.from + "</strong><br />" : "") + data.message + "</p>");
  });
  dispatcher.bind('connexion', function(data) {
    $("#container_msg").append("<p>" + data.message + "</p>");
  });
  dispatcher.bind('deconnexion', function(data) {
    $("#container_msg").append("<p>" + data.message + "</p>");
  });
});