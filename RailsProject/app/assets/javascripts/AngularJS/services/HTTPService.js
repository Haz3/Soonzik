SoonzikApp.factory('HTTPService', ['$http', '$location', 'Upload', function ($http, $location, Upload) {

	var url = "lvh.me:3000"

  function urlParametersFormat(array) {
    if (typeof array === "undefined" || array == null || array.length == 0)
      return "";

    parameters = ""
    for (var index in array) {
      if (index == 0) {
        parameters += "?"
      } else {
        parameters += "&"
      }
      parameters += array[index].key + "=" + array[index].value
    }
    return parameters;
  }

  return {
    getLastMessages: function (user_id, parameters) {
      return $http.get("http://api." + url + '/messages/conversation/' + user_id + urlParametersFormat(parameters));
    },
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
    getFollows: function (user_id) {
      return $http.get("http://api." + url + '/users/' + user_id + '/follows')
    },
    isArtist: function (user_id) {
    	return $http.get("http://api." + url + '/users/' + user_id + '/isartist')
    },
    updateUser: function (parameters) {
      return $http.post("http://api." + url + '/users/update', parameters)
    },
    uploadProfileImage: function (file, parameters, progressFunction, successFunction, errorFunction) {
      parameters.type = "image";
      Upload.upload({
        url: "http://api." + url + '/users/upload',
        fields: parameters,
        file: file
      }).progress(progressFunction)
      .success(successFunction)
      .error(errorFunction);
    },
    uploadBackgroundImage: function (file, parameters, progressFunction, successFunction, errorFunction) {
      parameters.type = "background";
      Upload.upload({
        url: "http://api." + url + '/users/upload',
        fields: parameters,
        file: file
      }).progress(progressFunction)
      .success(successFunction)
      .error(errorFunction);
    },
    indexPacks: function(parameters) {
      return $http.get("http://api." + url + '/packs' + urlParametersFormat(parameters));
    },
    findPacks: function (parameters) {
      return $http.get("http://api." + url + '/packs/find' + urlParametersFormat(parameters));
    },
    showPack: function(id) {
      return $http.get("http://api." + url + '/packs/' + id)
    },
    indexNews: function(parameters) {
      return $http.get("http://api." + url + '/news' + urlParametersFormat(parameters));
    },
    findNews: function(parameters) {
      return $http.get("http://api." + url + '/news/find' + urlParametersFormat(parameters));
    },
    showNews: function(id) {
      return $http.get("http://api." + url + '/news/' + id)
    },
    findBattles: function (parameters) {
      return $http.get("http://api." + url + '/battles/find' + urlParametersFormat(parameters));
    },
    indexBattles: function (parameters) {
      return $http.get("http://api." + url + '/battles' + urlParametersFormat(parameters));
    },
    showBattles: function (id) {
      return $http.get("http://api." + url + '/battles/' + id);
    },
    voteBattle: function (battleId, parameters) {
      return $http.post("http://api." + url + '/battles/' + battleId + '/vote', parameters);
    },
    getMP3musicURL: function(id, parameters) {
      return "http://api." + url + '/musics/get/' + id + urlParametersFormat(parameters);
    },
    getPlaylist: function(id) {
      return $http.get("http://api." + url + '/playlists/' + id);
    },
    findPlaylist: function(parameters) {
      return $http.get("http://api." + url + '/playlists/find' + urlParametersFormat(parameters));
    },
    destroyPlaylist: function(parameters) {
      return $http.get("http://api." + url + "/playlists/destroy" + urlParametersFormat(parameters));
    },
    deleteFromPlaylist: function(parameters) {
      return $http.get("http://api." + url + "/musics/delfromplaylist" + urlParametersFormat(parameters));
    },
    follow: function(parameters) {
      return $http.post("http://api." + url + "/users/follow", parameters);
    },
    unfollow: function(parameters) {
      return $http.post("http://api." + url + "/users/unfollow", parameters);
    },
    getMusic: function(id) {
      return $http.get("http://api." + url + "/musics/" + id);
    },
    savePlaylist: function(parameters) {
      return $http.post("http://api." + url + "/playlists/save", parameters);
    },
    addToPlaylist: function(parameters) {
      return $http.post("http://api." + url + "/musics/addtoplaylist", parameters);
    }
  }
}]);
