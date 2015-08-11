SoonzikApp.controller('AlbumsCtrl', ['$scope', "$routeParams", 'SecureAuth', 'HTTPService', 'NotificationService', function ($scope, $routeParams, SecureAuth, HTTPService, NotificationService) {
	$scope.loading = true;
	$scope.album = {};
	$scope.user = false;
	$scope.tooltip = false;
	$scope.selectedMusic = null;
	$scope.myPlaylists = [];

	$scope.commentariesOffset = 0;
	$scope.commentaries = [];
	$scope.commentLoading = false;
	$scope.comment = {
		value: ""
	};

	$scope.initAlbum = function() {
		var id = $routeParams.id;

		var current_user = SecureAuth.getCurrentUser();
		if (current_user.id != null && current_user.token != null && current_user.username != null) {
			$scope.user = current_user;
		}

		HTTPService.getAlbum(id).then(function(response) {
			$scope.album = response.data.content;

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
							}
						}
					}
				}, function(error) {
					NotificationService.error("Error while loading your notes");
				});

				if ($scope.user) {
					HTTPService.findPlaylist([{ key: "attribute[user_id]", value: $scope.user.id }]).then(function(response) {
			    	$scope.myPlaylists = response.data.content;
			    	for (var i = 0 ; i < $scope.myPlaylists.length ; i++) {
			    		$scope.myPlaylists[i].check = false;
			    	}
					}, function(error) {
						NotificationService.error("Error while deleting the playlist : " + playlist.name);
					});
				}
			}

			$scope.loading = false;
		}, function(error) {
			NotificationService.error("Error while loading the album");
		});

		$(window).scroll(function() {
			if($(window).scrollTop() + $(window).height() == $(document).height() && $scope.commentLoading == false) {
				$scope.$apply(function() {
					$scope.commentLoading = true;
					$scope.loadComments();
				});
			}
		});
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
		  			NotificationService.error("Error while saving a new music in the playlist");
		  		});
		  	}, function(error) {
		  		NotificationService.error("Error while saving a new music in the playlist");
		  	});
  	}
  }

	$scope.setGolden = function(music, index) {
		music.goldenStars = index;
	}

	$scope.setNote = function(music) {
		SecureAuth.securedTransaction(function (key, user_id) {
			HTTPService.setMusicNote(music.id, music.goldenStars, { user_id: user_id, secureKey: key }).then(function(response) {
				music.note = music.goldenStars;
			}, function(error) {
				NotificationService.error("Error while rating the music, please try later.");
			});
		}, function(error) {
			NotificationService.error("Error while rating the music, please try later.");
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
  		}
  	} else {
  		for (var i = 0 ; i < $scope.myPlaylists.length ; i++) {
 				$scope.myPlaylists[i].check = false;
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
  		NotificationService.error("Error while loading commentaries");
  	});
  }

  $scope.sendComment = function() {
  	SecureAuth.securedTransaction(function (key, user_id) {
			var parameters = { secureKey: key, user_id: user_id, content: $scope.comment.value };
			
			HTTPService.addAlbumComment($scope.album.id, parameters).then(function(response) {
				$scope.commentaries.unshift(response.data.content);
				$scope.commentariesOffset++;
			}, function (responseError) {
				NotificationService.error("Error while saving your comment, please try later");
			});
		}, function(error) {
			NotificationService.error("Error while saving your comment, please try later");
		});

  	
  }
}]);