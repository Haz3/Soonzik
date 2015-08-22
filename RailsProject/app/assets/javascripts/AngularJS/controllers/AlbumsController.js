SoonzikApp.controller('AlbumsCtrl', ['$scope', "$routeParams", 'SecureAuth', 'HTTPService', 'NotificationService', '$rootScope', function ($scope, $routeParams, SecureAuth, HTTPService, NotificationService, $rootScope) {
	$scope.loading = true;
	$scope.album = {};
	$scope.user = false;
	$scope.tooltip = false;
	$scope.selectedMusic = null;
	$scope.myPlaylists = [];

	$scope.commentariesOffset = 0;
	$scope.commentaries = [];
	$scope.commentLoading = true;
	$scope.comment = {
		value: ""
	};
	$scope.goldenLock = false;

	$scope.initAlbum = function() {
		var id = $routeParams.id;

		var current_user = SecureAuth.getCurrentUser();
		if (current_user.id != null && current_user.token != null && current_user.username != null) {
			$scope.user = current_user;
		}

		HTTPService.getAlbum(id).then(function(response) {
			$scope.album = response.data.content;
			$scope.loadComments();

			if ($scope.user != false) {
				var note_array_id = []

				for (var j = 0 ; j < $scope.album.musics.length ; j++) {
					note_array_id.push($scope.album.musics[j].id);
					$scope.album.musics[j].goldenStars = null;
				}

				var noteParameters = [
					{ key: "user_id", value: $scope.user.id },
					{ key: "arr_id", value: "[" + encodeURI(note_array_id) + "]" }
				]

				HTTPService.getMusicNotes(noteParameters).then(function(response) {
					for (var j = 0 ; j < $scope.album.musics.length ; j++) {
						for (var k = 0 ; k < response.data.content.length ; k++) {
							if (response.data.content[k].music_id == $scope.album.musics[j].id) {
								$scope.album.musics[j].note = response.data.content[k].note;
								$scope.album.musics[j].album = $scope.album;
							}
						}
					}
				}, function(error) {
					NotificationService.error($rootScope.labels.FILE_ALBUM_GET_NOTES_ERROR_MESSAGE);
				});

				if ($scope.user) {
					HTTPService.findPlaylist([{ key: "attribute[user_id]", value: $scope.user.id }]).then(function(response) {
			    	$scope.myPlaylists = response.data.content;
			    	for (var i = 0 ; i < $scope.myPlaylists.length ; i++) {
			    		$scope.myPlaylists[i].check = false;
			    		$scope.myPlaylists[i].original_check = false;
			    	}
					}, function(error) {
						NotificationService.error($rootScope.labels.FILE_ALBUM_FIND_PLAYLIST_ERROR_MESSAGE + playlist.name);
					});
				}
			}

			$(window).scroll(function() {
				if($(window).scrollTop() + $(window).height() == $(document).height() && $scope.commentLoading == false) {
					$scope.$apply(function() {
						$scope.commentLoading = true;
						$scope.loadComments();
					});
				}
			});

			$scope.loading = false;
		}, function(error) {
			NotificationService.error($rootScope.labels.FILE_ALBUM_GET_ALBUM_ERROR_MESSAGE);
		});
	}

	$scope.addToPlaylist = function() {
  	var playlist = false;

  	for (var i = 0 ; i < $scope.myPlaylists.length ; i++) {
  		if ($scope.myPlaylists[i].check == true) {
	  		playlist = $scope.myPlaylists[i];
		  	if ($scope.user != false && $scope.selectedMusic != false && playlist != false && playlist.check != playlist.original_check) {
		  		$scope.uploadAddToPlaylist($scope.selectedMusic, playlist);
		  	}
	  	}
  	}
  }

  $scope.uploadAddToPlaylist = function(music, playlist) {
  	SecureAuth.securedTransaction(function(key, user_id) {
  		var parameters = {
  			secureKey: key,
  			user_id: user_id,
				id: music.id,
				playlist_id: playlist.id
  		};
  		HTTPService.addToPlaylist(parameters).then(function(response) {
  			NotificationService.success($rootScope.labels.FILE_ALBUM_ADD_PLAYLIST_NOTIF_SUCCESS_PART_ONE + music.title + $rootScope.labels.FILE_ALBUM_ADD_PLAYLIST_NOTIF_SUCCESS_PART_TWO);
  			$rootScope.$broadcast("player:addToPlaylist", { playlist: playlist, music: music });
  			$scope.selectedMusic = false;
  			$scope.tooltip = false;
  			playlist.original_check = true;
  			playlist.check = true;
  		}, function(error) {
  			NotificationService.error($rootScope.labels.FILE_ALBUM_ADD_PLAYLIST_ERROR_MESSAGE);
  		});
  	}, function(error) {
  		NotificationService.error($rootScope.labels.FILE_ALBUM_ADD_PLAYLIST_ERROR_MESSAGE);
  	});
  }

	$scope.setGolden = function(music, index) {
		if ($scope.goldenLock == false) {
			music.goldenStars = index;
		}
	}

	$scope.setNote = function(music) {
		$scope.goldenLock = true;
		SecureAuth.securedTransaction(function (key, user_id) {
			HTTPService.setMusicNote(music.id, music.goldenStars, { user_id: user_id, secureKey: key }).then(function(response) {
				music.note = music.goldenStars;
				$scope.goldenLock = false;
			}, function(error) {
				NotificationService.error($rootScope.labels.FILE_ALBUM_SET_NOTE_ERROR_MESSAGE);
			});
		}, function(error) {
			NotificationService.error($rootScope.labels.FILE_ALBUM_SET_NOTE_ERROR_MESSAGE);
		});
	}

  $scope.selectMusic = function(music) {
  	if ($scope.selectedMusic == music) {
  		$scope.selectedMusic = false;
  	} else {
	  	$scope.selectedMusic = music;
	  }
  }

  $scope.setTooltip = function(value) {
  	$scope.tooltip = value;
  	if ($scope.tooltip != false) {
  		for (var i = 0 ; i < $scope.myPlaylists.length ; i++) {
  			for (var j = 0 ; j < $scope.myPlaylists[i].musics.length ; j++) {
  				if (value.id == $scope.myPlaylists[i].musics[j].id) {
  					$scope.myPlaylists[i].check = true;
  				}
  			}
  			$scope.myPlaylists[i].original_check = $scope.myPlaylists[i].check;
  		}
  	} else {
  		for (var i = 0 ; i < $scope.myPlaylists.length ; i++) {
 				$scope.myPlaylists[i].check = false;
 				$scope.myPlaylists[i].original_check = false;
  		}
  		$scope.selectMusic(false);
  	}
  }

	$scope.range = function(n) {
		if (n > 0)
	  	return new Array(n);
	  else
	  	return []
  };

  $scope.formatTime = function(duration) {
  	var min = ~~(duration / 60);
  	var sec = duration % 60;

  	if (min.toString().length == 1)
  		min = "0" + min;
  	if (sec.toString().length == 1)
  		sec = "0" + sec;
  	return min + ":" + sec;
  }

  $scope.loadComments = function() {
  	var params = [
  		{ key: "offset", value: $scope.commentariesOffset },
  		{ key: "limit", value: 20 }
  	];
  	HTTPService.getAlbumComments($scope.album.id, params).then(function(response) {
  		$scope.commentaries = $scope.commentaries.concat(response.data.content);
  		$scope.commentariesOffset = $scope.commentaries.length;
			$scope.commentLoading = false;
  	}, function(error) {
  		NotificationService.error($rootScope.labels.FILE_ALBUM_LOAD_COMMENT_ERROR_MESSAGE);
  	});
  }

  $scope.sendComment = function() {
  	SecureAuth.securedTransaction(function (key, user_id) {
			var parameters = { secureKey: key, user_id: user_id, content: $scope.comment.value };
			
			HTTPService.addAlbumComment($scope.album.id, parameters).then(function(response) {
				$scope.commentaries.unshift(response.data.content);
				$scope.commentariesOffset++;
				$scope.comment.value = "";
			}, function (responseError) {
				NotificationService.error($rootScope.labels.FILE_ALBUM_SEND_COMMENT_ERROR_MESSAGE);
			});
		}, function(error) {
			NotificationService.error($rootScope.labels.FILE_ALBUM_SEND_COMMENT_ERROR_MESSAGE);
		});

  	
  }
}]);