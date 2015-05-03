SoonzikApp.factory('HTTPService', ['$http', '$location', function ($http, $location) {

	var url = "lvh.me:3000"

  return {
      getProfile: function (user_id) {
          return $http.get("http://api." + url + '/users/' + user_id);
      }
  }
}]);
