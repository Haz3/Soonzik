SoonzikApp.factory('HTTPService', ['$http', '$location', function ($http, $location) {

	var url = "lvh.me:3000"

  return {
      getProfile: function (user_id) {
        return $http.get("http://api." + url + '/users/' + user_id);
      },
      getFullProfile: function (user_id) {
        return $http.get("http://" + url + '/users/' + user_id + '/edit.json');
      },
      getFriends: function (user_id) {
      	return $http.get("http://api." + url + '/users/' + user_id + '/friends')
      },
      getFollowers: function (user_id) {
      	return $http.get("http://api." + url + '/users/' + user_id + '/followers')
      },
      isArtist: function (user_id) {
      	return $http.get("http://api." + url + '/users/' + user_id + '/isartist')
      },
      updateUser: function (parameters) {
        return $http.post("http://api." + url + '/users/update', parameters)
      }
  }
}]);
