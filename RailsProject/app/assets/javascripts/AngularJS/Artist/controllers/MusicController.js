SoonzikArtistApp.controller('MusicCtrl', ['$scope', 'SecureAuth', 'HTTPService', 'NotificationService', '$timeout', '$modal', function ($scope, SecureAuth, HTTPService, NotificationService, $timeout, $modal) {

	$scope.loading = true;
	$scope.albums = [];
	$scope.noLinkMusics = [];
	$scope.user = false;
	$scope.influences = [];

	var music_drop = null;
	var container_drop = null;
	var album_drop = null;

	// Init function
	$scope.musicInit = function() {
		var current_user = SecureAuth.getCurrentUser();
		if (current_user.id != null && current_user.token != null && current_user.username != null) {
			$scope.user = current_user;
		}

		var parameters = [
			{ key: "attribute[user_id]", value: $scope.user.id }
		];

		HTTPService.findAlbums(parameters).then(function(response) {
			$scope.albums = response.data.content;

			HTTPService.findMusics(parameters).then(function(response) {
				for (var i = 0 ; i < response.data.content.length ; i++) {
					var inAlbum = false;
					for (var j = 0 ; j < $scope.albums.length ; j++) {
						inAlbum = inAlbum || isInAlbum(response.data.content[i], $scope.albums[j]);
					}
					if (inAlbum == false) {
						$scope.noLinkMusics.push(response.data.content[i]);
					}
				}

				HTTPService.indexInfluences().then(function(response) {
					$scope.influences = response.data.content;
					$scope.loading = false;
				}, function(error) {
					NotificationService.error("An error occured while loading");
				});
			}, function(error) {
				NotificationService.error("An error occured while loading");
			});
		}, function(error) {
			NotificationService.error("An error occured while loading");
		});
	}

	// To know if a music is in the specific album
	var isInAlbum = function(music, album) {
		for (var i = 0 ; i < album.musics.length ; i++) {
			if (album.musics[i].id == music.id) {
				album.musics[i] = music;
				return true;
			}
		}
		return false;
	}

	// Callback on drop
	$scope.musicDrop = function(list, music, album_id) {
		music_drop = music;
		container_drop = list;
		album_drop = album_id;
		return music;
	}

	// Callback after the drop
	$scope.musicMoved = function(listFrom, index) {
		elem = listFrom.splice(index, 1);
		var parameters = {
			id: music_drop.id,
			music: {
				album_id: album_drop
			}
		};
		HTTPService.updateMusic(parameters).then(function(response) {
			music_drop = null;
			container_drop = null;
			album_drop = null;
		}, function(error) {
			listFrom.push(elem);
		});

		return true;
	}

	// For the edition of a music
	$scope.editMusic = function(music) {
    var modalInstance = $modal.open({
      templateUrl: '/assets/AngularJS/Artist/views/modalEditMusic.html.haml',
      controller: 'ModalInstanceEditMusicCtrl',
      resolve: {
      	influences: function() {
      		return $scope.influences;
      	},
      	music: function() {
      		return music;
      	}
      }
    });

    modalInstance.result.then(function (newMusic) {
    	console.log(newMusic);
    	music.title = newMusic.title;
    	music.price = newMusic.price;
    	music.limited = newMusic.limited;
    	music.genres = newMusic.genres;
    }, function () {
    });
	}

	// For the edition of an album
	$scope.editAlbum = function(album) {
		var modalInstance = $modal.open({
      templateUrl: '/assets/AngularJS/Artist/views/modalAlbum.html.haml',
      controller: 'ModalInstanceEditAlbumCtrl',
      resolve: {
      	influences: function() {
      		return $scope.influences;
      	},
      	album: function() {
      		return album;
      	}
      }
    });

    modalInstance.result.then(function (newAlbum) {
    	console.log(newAlbum);
    	for (var i = 0 ; i < $scope.albums.length ; i++) {
    		if ($scope.albums[i].id == album.id) {
    			$scope.albums[i] = newAlbum;
    			break;
    		}
    	}
    }, function () {
    });
	}

	// For the modal
	// Upload a music
	$scope.openMusic = function () {
    var modalInstance = $modal.open({
      templateUrl: '/assets/AngularJS/Artist/views/modalMusic.html.haml',
      controller: 'ModalInstanceMusicCtrl',
      resolve: {
      	influences: function() {
      		return $scope.influences;
      	}
      }
    });

    modalInstance.result.then(function (music) {
    	$scope.noLinkMusics.push(music);
    }, function () {
    });
  };

	// For the modal
	// Create an album
	$scope.openAlbum = function () {
    var modalInstance = $modal.open({
      templateUrl: '/assets/AngularJS/Artist/views/modalAlbum.html.haml',
      controller: 'ModalInstanceAlbumCtrl',
      resolve: {
      	influences: function() {
      		return $scope.influences;
      	}
      }
    });

    modalInstance.result.then(function (album) {
    	$scope.albums.push(album);
    }, function () {
    });
  };
}]);


/*
	*****************************
	The modal to upload a music
	*****************************
*/

SoonzikArtistApp.controller('ModalInstanceMusicCtrl', ["$scope", "$modalInstance", "Upload", "HTTPService", "NotificationService", "influences", function ($scope, $modalInstance, Upload, HTTPService, NotificationService, influences) {
	$scope.loading = false;
	$scope.file = null;
	$scope.form = {
		title: "",
		price: 0,
		limited: "true"
	};
	$scope.influences = influences;
	$scope.selected = {
		selectedGenres: []
	}

	// On the save button
  $scope.ok = function () {
  	var parameters = { music: $scope.form, genres: $scope.selected.selectedGenres };
  	HTTPService.uploadMusic($scope.file, parameters, function (evt) {
			$scope.loading = true;
		}, function (data, status, headers, config) {
			$scope.loading = false;
			if (data.error == true)
				alert("Nein nein nein !");
			else
				$modalInstance.close(data.music);
		}, function (error) {
			$scope.loading = false;
			NotificationService.error("Error while saving the informations");
		});
  };

  // On the background click
  $scope.cancel = function () {
    $modalInstance.dismiss('cancel');
  };

  // The file chooser callback
  $scope.uploadMusic = function($file) {
  	if ($file && $file.length) {
			for (var i = 0; i < $file.length; i++) {
				var file = $file[i];

				$scope.file = file;
			}
    }
	}
}]);

/*
	*****************************
	The modal to create an album
	*****************************
*/

SoonzikArtistApp.controller('ModalInstanceAlbumCtrl', ["$scope", "$modalInstance", "Upload", "HTTPService", "NotificationService", "influences", function ($scope, $modalInstance, Upload, HTTPService, NotificationService, influences) {
	$scope.loading = false;
	$scope.file = null;
	$scope.form = {
		title: "",
		price: 0,
		yearProd: 2000
	};
	$scope.descriptions = []
	$scope.influences = influences;
	$scope.selected = {
		selectedGenres: []
	}

	// On the save button
  $scope.ok = function () {
  	var parameters = {
  		album: $scope.form,
  		descriptions: $scope.descriptions,
  		genres: $scope.selected.selectedGenres
  	};

  	HTTPService.addAlbum($scope.file, parameters, function (evt) {
			$scope.loading = true;
		}, function (data, status, headers, config) {
			$scope.loading = false;
			$modalInstance.close(data.album);
		}, function (error) {
			$scope.loading = false;
			NotificationService.error("Error while saving the informations");
		});
  };

  // On the background click
  $scope.cancel = function () {
    $modalInstance.dismiss('cancel');
  };

  // The file chooser callback
  $scope.uploadImage = function($file) {
  	if ($file && $file.length) {
			for (var i = 0; i < $file.length; i++) {
				var file = $file[i];

				$scope.file = file;
			}
    }
	}
}]);

/*
	*****************************
	The modal to update an album
	*****************************
*/

SoonzikArtistApp.controller('ModalInstanceEditAlbumCtrl',
														["$scope", "$modalInstance", "Upload", "HTTPService", "NotificationService", "influences", "album",
														function ($scope, $modalInstance, Upload, HTTPService, NotificationService, influences, album) {
	$scope.loading = false;

	var formatGenre = function(genres) {
		var array = [];
		for (var i = 0 ; i < genres.length ; i++) {
			array.push(genres[i].id);
		}
		return array;
	}

	$scope.file = null;
	$scope.form = {
		title: album.title,
		price: album.price,
		yearProd: album.yearProd
	};
	$scope.descriptions = []
	$scope.influences = influences;
	$scope.selected = {
		selectedGenres: formatGenre(album.genres)
	}

	// On the save button
  $scope.ok = function () {
  	var parameters = {
  		id: album.id,
  		album: $scope.form,
  		descriptions: $scope.descriptions,
  		genres: $scope.selected.selectedGenres
  	};

  	HTTPService.updateAlbum($scope.file, parameters, function (evt) {
			$scope.loading = true;
		}, function (data, status, headers, config) {
			$scope.loading = false;
			$modalInstance.close(data.album);
		}, function (error) {
			$scope.loading = false;
			NotificationService.error("Error while saving the informations");
		});
  };

  // On the background click
  $scope.cancel = function () {
    $modalInstance.dismiss('cancel');
  };

  // The file chooser callback
  $scope.uploadImage = function($file) {
  	if ($file && $file.length) {
			for (var i = 0; i < $file.length; i++) {
				var file = $file[i];

				$scope.file = file;
			}
    }
	}
}]);

/*
	*****************************
	The modal to update a music
	*****************************
*/

SoonzikArtistApp.controller('ModalInstanceEditMusicCtrl', ["$scope", "$modalInstance", "HTTPService", "NotificationService", "influences", "music",
														function ($scope, $modalInstance, HTTPService, NotificationService, influences, music) {
	$scope.loading = false;

	var formatGenre = function(genres) {
		var array = [];
		for (var i = 0 ; i < genres.length ; i++) {
			array.push(genres[i].id);
		}
		return array;
	}

	$scope.form = {
		title: music.title,
		price: music.price,
		limited: music.limited.toString()
	};
	$scope.influences = influences;
	$scope.selected = {
		selectedGenres: formatGenre(music.genres)
	}

	// On the save button
  $scope.ok = function () {
  	var parameters = {
  		id: music.id,
  		music: $scope.form,
  		genres: $scope.selected.selectedGenres
  	};
  	$scope.loading = true;
  	HTTPService.updateMusic(parameters).then(function(response) {
			$scope.loading = false;
			$modalInstance.close(response.data.music);
  	}, function(error) {
  		NotificationService.error("Error while saving the informations");
  	});
  };

  // On the background click
  $scope.cancel = function () {
    $modalInstance.dismiss('cancel');
  };
}]);