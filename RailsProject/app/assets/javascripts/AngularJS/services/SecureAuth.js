SoonzikApp.factory('SecureAuth', ['$http', '$routeParams', '$location', '$cookies', '$timeout', function ($http, $routeParams, $location, $cookies, $timeout) {

	var url = "lvh.me:3000";
  var isUsed = false;
  var last_update = null;
  var last_key = null;

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
        if (isUsed) {
          var that = this;
          $timeout(function() {
            that.securedTransaction(securedFunctionSuccess, securedFunctionError);
          }, 500);
        } else {
          d = new Date();
          var user = { id: null, token: null }
          if (typeof $cookies.get("user_id") !== "undefined" &&
              typeof $cookies.get("user_token") !== "undefined") {
            user.id = $cookies.get("user_id");
            user.token = $cookies.get("user_token");
          }

          if (last_update == null || (last_update + 280) * 1000 < d.getTime() || last_key == null) {
            isUsed = true;
            /*
             * If we need a valid token
             */
    		    $http.get("http://api." + url + '/getKey/' + user.id).then(function (json) {
              isUsed = false;

    		    	var key_obj = new jsSHA(user.token + json.data.key, "TEXT");
    					var key = key_obj.getHash("SHA-256", "HEX");
              
              last_update = Math.floor(d.getTime() / 1000);
              last_key = key;
    		    	
    		    	securedFunctionSuccess(key, user.id);
    		    }, function(error) {
              isUsed = false;
              securedFunctionError(error);
            });
            /********************************/
          } else {
            /*
             * If we have a valid token
             */
            securedFunctionSuccess(last_key, user.id);
          }
        }
      },
      getLanguage: function() {
        if (typeof $cookies.get("language") !== "undefined") {
          return $cookies.get("language");
        } else {
          return "EN";
        }
      }
  }
}]);