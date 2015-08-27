SoonzikApp.controller('DiscothequeCtrl', ['$scope', 'SecureAuth', 'HTTPService', '$rootScope', 'NotificationService', function ($scope, SecureAuth, HTTPService, $rootScope, NotificationService) {

	$scope.loading = true;
	$scope.user = false;
	$scope.mymusic = { musics: [], albums: [], packs: [] };

	$scope.discoInit = function() {
		var current_user = SecureAuth.getCurrentUser();
		if (current_user.id != null && current_user.token != null && current_user.username != null) {
			$scope.user = current_user;
		}
		if ($scope.user == false) {
			NotificationService.error
			$scope.loading = false;
		} else {
			SecureAuth.securedTransaction(function(key, user_id) {
	  		var params = [
	  			{ key: "user_id", value: user_id},
	  			{ key: "secureKey", value: key }
	  		];
	  		HTTPService.getMyMusic(params).then(function(response) {
	  			$scope.mymusic = response.data.content;

	  			var arr_mus_id = [];
	  			var arr_alb_id = [];
	  			var arr_pack_id = [];

	  			/*
						GET NOTE MUSICS
	  			*/
	  			for (var i = 0 ; i < $scope.mymusic.musics.length ; i++) {
	  				arr_mus_id.push($scope.mymusic.musics[i].id);
	  			}
	  			var noteParametersMusics = [
						{ key: "user_id", value: $scope.user.id },
						{ key: "arr_id", value: "[" + encodeURI(arr_mus_id) + "]" }
					]

					if (arr_mus_id.length > 0) {
						HTTPService.getMusicNotes(noteParametersMusics).then(function(response) {
			  			for (var ibis = 0 ; ibis < $scope.mymusic.musics.length ; ibis++) {
			  				// iteration on notes
			  				for (var jbis = 0 ; jbis < response.data.content.length ; jbis++) {
			  					if (response.data.content[jbis].music_id == $scope.mymusic.musics[ibis].id) {
			  						console.log(response.data.content[jbis]);
			  						$scope.mymusic.musics[ibis].note = response.data.content[jbis].note;
					  				$scope.mymusic.musics[ibis].goldenStars = $scope.mymusic.musics[ibis].note;
					  				break;
					  			}
				  			}
			  			}
			  		}, function(error) {
			  			NotificationService.error(" labels.note ");
			  		});
					}

		  		/*
						GET NOTE ALBUMS
		  		*/
	  			for (var i = 0 ; i < $scope.mymusic.albums.length ; i++) {
	  				for (var j = 0 ; j < $scope.mymusic.albums[i].album.musics.length ; j++) {
	  					arr_alb_id.push($scope.mymusic.albums[i].album.musics[j].id);
	  				}
	  			}

	  			var noteParametersAlbums = [
						{ key: "user_id", value: $scope.user.id },
						{ key: "arr_id", value: "[" + encodeURI(arr_alb_id) + "]" }
					]

					if (arr_alb_id.length > 0) {
						HTTPService.getMusicNotes(noteParametersAlbums).then(function(response) {
			  			for (var ibis = 0 ; ibis < $scope.mymusic.albums.length ; ibis++) {
			  				for (var jbis = 0 ; jbis < $scope.mymusic.albums[ibis].album.musics.length ; jbis++) {

			  					// iteration on notes
			  					for (var kbis = 0 ; kbis < response.data.content.length ; kbis++) {
				  					if (response.data.content[kbis].music_id == $scope.mymusic.albums[ibis].album.musics[jbis].id) {
					  					$scope.mymusic.albums[ibis].album.musics[jbis].note = response.data.content[kbis].note;
					  					$scope.mymusic.albums[ibis].album.musics[jbis].goldenStars = $scope.mymusic.albums[ibis].album.musics[jbis].note;
					  					break;
					  				}
					  			}
			  				}
			  			}
			  		}, function(error) {
			  			NotificationService.error(" labels.note ");
			  		});
					}


		  		/*
						GET NOTE PACKS
		  		*/
	  			
	  			/*for (var i = 0 ; i < $scope.mymusic.packs.length ; i++) {
	  				for (var j = 0 ; j < $scope.mymusic.packs[i].albums.length ; j++) {
		  				for (var k = 0 ; k < $scope.mymusic.packs[i].albums[j].musics.length ; k++) {
		  					arr_pack_id.push($scope.mymusic.packs[i].albums[j].musics[k].id);
		  				}
		  			}
	  			}

	  			var noteParametersPacks = [
						{ key: "user_id", value: $scope.user.id },
						{ key: "arr_id", value: "[" + encodeURI(arr_pack_id) + "]" }
					]

					if (arr_pack_id.length > 0) {
		  			HTTPService.getMusicNotes(noteParametersPacks).then(function(response) {
			  			console.log(response);
			  			/*
			  			for (var i = 0 ; i < $scope.mymusic.packs.length ; i++) {
			  				for (var j = 0 ; j < $scope.mymusic.packs[i].albums.length ; j++) {
				  				for (var k = 0 ; k < $scope.mymusic.packs[i].albums[j].musics.length ; k++) {
				  					$scope.mymusic.packs[i].albums[j].musics[k].goldenStars = $scope.mymusic.packs[i].albums[j].musics[k].note;
				  				}
				  			}
			  			}
			  		//
			  		}, function(error) {
			  			NotificationService.error(" labels.note ");
			  		});
		  		}*/


					$scope.loading = false;
	  		}, function(error) {
	  			NotificationService.error(" labels. ");
	  		});
			}, function(error) {
	 			NotificationService.error(" labels. ");
			});
		}
	}

	// Utils

	$scope.setGolden = function(music, index) {
		music.goldenStars = index;
	}

	$scope.setNote = function(music) {
		if ($scope.user != false) {
			SecureAuth.securedTransaction(function (key, user_id) {
				HTTPService.setMusicNote(music.id, music.goldenStars, { user_id: user_id, secureKey: key }).then(function(response) {
					music.note = music.goldenStars;
				}, function(error) {
					NotificationService.error($rootScope.labels.FILE_USER_SET_NOTE_ERROR_MESSAGE);
				});
			}, function(error) {
				NotificationService.error($rootScope.labels.FILE_USER_SET_NOTE_ERROR_MESSAGE);
			});
		} else {
			NotificationService.info($rootScope.labels.FILE_USER_NEED_LOGIN_ERROR_MESSAGE);
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
						NotificationService.error($rootScope.labels.FILE_USER_ADD_PLAYLIST_ERROR_MESSAGE);
					});
				}, function(error) {
					NotificationService.error($rootScope.labels.FILE_USER_ADD_PLAYLIST_ERROR_MESSAGE);
				});
		}
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


}]);