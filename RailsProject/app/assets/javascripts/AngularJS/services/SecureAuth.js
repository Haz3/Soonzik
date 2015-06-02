SoonzikApp.factory('SecureAuth', ['$http', '$routeParams', '$location', '$cookies', function ($http, $routeParams, $location, $cookies) {

	var url = "lvh.me:3000";

  return {
      getCurrentUser: function () {
      	var user = { id: null, token: null, username: null }
      	if (typeof $cookies.get("user_id") !== "undefined")
      		user.id = $cookies.get("user_id");
      	if (typeof $cookies.get("user_token") !== "undefined")
      		user.token = $cookies.get("user_token");
      	if (typeof $cookies.get("user_username") !== "undefined")
      		user.username = $cookies.get("user_username");
      	return user;
      },
      securedTransaction: function(securedFunctionSuccess, securedFunctionError) {
      	var user = { id: null, token: null }
      	if (typeof $cookies.get("user_id") !== "undefined" &&
      			typeof $cookies.get("user_token") !== "undefined") {
	        user.id = $cookies.get("user_id");
	      	user.token = $cookies.get("user_token");
        }
		    $http.get("http://api." + url + '/getKey/' + user.id).then(function (json) {
		    	var key_obj = new jsSHA(user.token + json.data.key, "TEXT");
					var key = key_obj.getHash("SHA-256", "HEX");
		    	
		    	securedFunctionSuccess(key, user.id);
		    }, securedFunctionError);
      }
  }
}]);