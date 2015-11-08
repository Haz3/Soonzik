SoonzikApp.controller('PlaylistsCtrl', ['$scope', "$rootScope", "$routeParams", 'SecureAuth', 'HTTPService', 'NotificationService', function ($scope, $rootScope, $routeParams, SecureAuth, HTTPService, NotificationService) {
	$scope.loading = true;

	$scope.id = false;
	$scope.tmp = false;
	$scope.user = false;
	$scope.playlist = { id: null, name: null, musics: [], user: null }
	$scope.tooltip = false;
	$scope.newItem = { name: "" }
	$scope.selectedMusic = false;
	$scope.myPlaylists = [];

	$scope.showInit = function() {
		var id = $routeParams.id;
		var current_user = SecureAuth.getCurrentUser();
		if (current_user.id != null && current_user.token != null && current_user.username != null) {
			$scope.user = current_user;
		}

		if ($.isNumeric(id)) {
			$scope.id = parseInt(id);
		} else if (/tmp:(\d*;)+/.test(id)) {
			$scope.id = id.substring(4).split(";");
			$scope.tmp = true;

			for (var i = 0 ; i < $scope.id.length ; i++) {
				if ($scope.id[i].length == 0 || toInt($scope.id[i]) == false) {
					$scope.id.splice(i, 1);
					i--;
				} else {
					$scope.id[i] = toInt($scope.id[i]);
				}
			}
		} else {
			NotificationService.error($rootScope.labels.FILE_PLAYLIST_BAD_ARGUMENT_ERROR_MESSAGE);
		}

		if ($scope.user) {
	    	SecureAuth.securedTransaction(function(key, id) {
		        var parameters = [
		          { key: "secureKey", value: key },
		          { key: "user_id", value: id },
		          { key: "attribute[user_id]", value: $scope.user.id }
		        ];
				HTTPService.findPlaylist(parameters).then(function(response) {
			    	$scope.myPlaylists = response.data.content;
			    	for (var i = 0 ; i < $scope.myPlaylists.length ; i++) {
			    		$scope.myPlaylists[i].check = false;
			    	}
		  		}, function(error) {
		  			NotificationService.error($rootScope.labels.FILE_PLAYLIST_FIND_PLAYLIST_ERROR_MESSAGE + playlist.name);
		  		});
  			});
		}

		if ($scope.id != false)
			loadMusics();
	}

	var loadMusics = function() {
		if ($scope.tmp) {
			$scope.playlist.id = null;
			$scope.playlist.name = $rootScope.labels.FILE_PLAYLIST_TMP_NAME_LABEL;
			for (var i = 0 ; i < $scope.id.length ; i++) {
				getMusic($scope.id[i], i);
			}
		} else {
			SecureAuth.securedTransaction(function(key, id) {
				var parameters = [
				  { key: "secureKey", value: key },
				  { key: "user_id", value: id }
				];
				HTTPService.getPlaylist($scope.id, parameters).then(function(response) {
					$scope.playlist = response.data.content;
					$scope.loading = false;
				}, function(error) {
					NotificationService.error($rootScope.labels.FILE_PLAYLIST_GET_PLAYLIST_ERROR_MESSAGE);
				});
			});
		}
	}

	var getMusic = function(id, index) {
		SecureAuth.securedTransaction(function(key, id) {
			var parameters = [
			  { key: "secureKey", value: key },
			  { key: "user_id", value: id },
			  { key: "attribute[user_id]", value: $scope.user.id }
			];
			HTTPService.getMusic(id).then(function(response) {
				$scope.playlist.musics[index] = response.data.content;
				if (index + 1 == $scope.id.length) {
					$scope.loading = false;
				}
			}, function(error) {
				NotificationService.error($rootScope.labels.FILE_PLAYLIST_GET_MUSIC_ERROR_MESSAGE + i);
			});
		});
	}

  $scope.formatTime = function(duration) {
  	var min = ~~(duration / 60);
  	var sec = duration % 60;

  	if (min.toString().length == 1)
  		min = "0" + min;
  	if (sec.toString().length == 1)
  		sec = "0" + sec;
  	return min + ":" + sec;
  }

  $scope.setTooltip = function(value) {
  	$scope.tooltip = value;
  	if ($scope.tooltip != false) {
  		$scope.tooltip.type = "music"
  		for (var i = 0 ; i < $scope.myPlaylists.length ; i++) {
  			for (var j = 0 ; j < $scope.myPlaylists[i].musics.length ; j++) {
  				if (value.id == $scope.myPlaylists[i].musics[j].id) {
  					$scope.myPlaylists[i].check = true;
  				}
  			}
  		}
  	} else {
  		for (var i = 0 ; i < $scope.myPlaylists.length ; i++) {
 				$scope.myPlaylists[i].check = false;
  		}
  		$scope.selectMusic(false);
  	}
  }

  $scope.toolTipShare = function() {
  	if ($scope.tooltip == false || $scope.tooltip.type != "share") {
  		$scope.tooltip = { type: "share", value: "http://lvh.me:3000/playlists/" + $routeParams.id };
  	} else {
  		$scope.tooltip = false;
  	}
  }

  $scope.saveTooltip = function() {
  	if ($scope.tooltip == false || $scope.tooltip.type != "save") {
  		$scope.tooltip = { type: "save" };
  	} else {
  		$scope.tooltip = false;
  	}
  }

  $scope.savePlaylist = function() {
  	SecureAuth.securedTransaction(function(key, user_id) {
  		var parameters = {
  			secureKey: key,
  			user_id: user_id,
  			playlist: {
  				name: $scope.newItem.name,
  				user_id: user_id
  			}
  		};
  		HTTPService.savePlaylist(parameters).then(function(response) {
  			$scope.newItem.name = "";
  			var musics = [];
  			var duration = 0;

  			for (var i = 0 ; i < $scope.playlist.musics.length ; i++) {
  				musics.push($scope.playlist.musics[i]);
  				duration += $scope.playlist.musics[i].duration;
  				SecureAuth.securedTransaction(function(key, user_id) {
			  		var parameters = {
			  			secureKey: key,
			  			user_id: user_id,
		  				id: $scope.playlist.musics[i].id,
		  				playlist_id: response.data.content.id
			  		};
			  		HTTPService.addToPlaylist(parameters).then(function(response) {
			  		}, function(error) {
			  			NotificationService.error("Error while saving a new music");
			  		});
			  	});
  			}
			NotificationService.success("The playlist '" + $scope.newItem.name + "' has been created");
			var pl = response.data.content;
			pl.musics = musics;
			pl.duration = duration;
  			$rootScope.$broadcast("player:newPlaylist", pl);
  			$scope.tooltip = false;
  		}, function(error) {
  			NotificationService.error($rootScope.labels.FILE_PLAYLIST_SAVE_PLAYLIST_ERROR_MESSAGE);
  		});
  	});
  }

  $scope.selectMusic = function(music) {
  	if ($scope.selectedMusic == music) {
  		$scope.selectedMusic = false;
  	} else {
	  	$scope.selectedMusic = music;
	  }
  }

  $scope.addToPlaylist = function() {
  	var playlist = false;

  	for (var i = 0 ; i < $scope.myPlaylists.length ; i++) {
  		if ($scope.myPlaylists[i].check == true)
	  		playlist = $scope.myPlaylists[i];
  	}

  	if ($scope.user != false && $scope.selectedMusic != false && playlist != false) {
  		SecureAuth.securedTransaction(function(key, user_id) {
	  		var parameters = {
	  			secureKey: key,
	  			user_id: user_id,
  				id: $scope.selectedMusic.id,
  				playlist_id: playlist.id
	  		};
	  		HTTPService.addToPlaylist(parameters).then(function(response) {
	  			NotificationService.success("The music '" + $scope.selectedMusic.title + "' has been added to the playlist");
	  			$rootScope.$broadcast("player:addToPlaylist", { playlist: playlist, music: $scope.selectedMusic });
	  			$scope.selectedMusic = false;
	  			$scope.tooltip = false;
	  			playlist.check = false;
	  		}, function(error) {
	  			NotificationService.error($rootScope.labels.FILE_PLAYLIST_NEW_MUSIC_ERROR_MESSAGE);
	  		});
	  	});
  	}
  }

	var toInt = function(value) {
		var tmp = parseInt(value);

		if (isNaN(tmp)) {
			return false;
		}
		return tmp;
	}

	$scope.listenPlaylist = function() {
		$rootScope.$broadcast("player:addPlaylist", { list: $scope.playlist.musics });
	}

	$scope.$on("newPlaylist", function(event, data) {
		$scope.myPlaylists.push(data);
	});

	$scope.$on("deletePlaylist", function(event, data) {
		for (var i = 0 ; i < $scope.myPlaylists.length ; i++) {
			if (data.id == $scope.myPlaylists[i].id) {
				$scope.myPlaylists.splice(i, 1);
				break;
			}
		}
	});
}]);