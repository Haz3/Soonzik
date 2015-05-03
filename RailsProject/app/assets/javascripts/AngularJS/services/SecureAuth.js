SoonzikApp.factory('SecureAuth', ['$http', '$routeParams', '$location', '$cookies', function ($http, $routeParams, $location, $cookies) {

	var url = "lvh.me:3000";

  return {
      getCurrentUser: function () {
      	var user = { id: null, token: null, username: null }
      	if (typeof $cookies.user_id !== "undefined")
      		user.id = $cookies.user_id;
      	if (typeof $cookies.user_token !== "undefined")
      		user.token = $cookies.user_token;
      	if (typeof $cookies.user_username !== "undefined")
      		user.username = $cookies.user_username;
      	return user;
      },
      securedTransaction: function(securedFunctionSuccess, securedFunctionError) {
      	var user = { id: null, token: null }
      	if (typeof $cookies.user_id !== "undefined" &&
      			typeof $cookies.user_token !== "undefined") {
	        user.id = $cookies.user_id;
	      	user.token = $cookies.user_token;
        }
		    $http.get("http://api." + url + '/getKey/' + user.id).then(function (json) {
		    	var key_obj = new jsSHA(user.token + json.data.key, "TEXT");
					var key = key_obj.getHash("SHA-256", "HEX");
		    	
		    	securedFunctionSuccess(key, user.id);
		    }, securedFunctionError);
      }
  }
}]);