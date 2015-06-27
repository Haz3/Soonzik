SoonzikArtistApp.controller('MusicCtrl', ['$scope', 'SecureAuth', 'HTTPService', 'NotificationService', '$timeout', '$modal', function ($scope, SecureAuth, HTTPService, NotificationService, $timeout, $modal) {

	$scope.loading = true;
	$scope.albums = [];
	$scope.noLinkMusics = [];
	$scope.user = false;
	$scope.influences = [];

	var music_drop = null;
	var container_drop = null;
	var album_drop = null;

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
						inAlbum = inAlbum || isInAlbum(response.data.content[i].id, $scope.albums[j]);
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

	var isInAlbum = function(music_id, album) {
		for (var i = 0 ; i < album.musics.length ; i++) {
			if (album.musics[i].id == music_id) {
				return true;
			}
		}
		return false;
	}

	$scope.musicDrop = function(list, music, album_id) {
		music_drop = music;
		container_drop = list;
		album_drop = album_id;
		return music;
	}

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
			console.log(response);
		}, function(error) {
			console.log(error);
			listFrom.push(elem);
		});

		return true;
	}

	// For the modal
	$scope.open = function () {
    var modalInstance = $modal.open({
      templateUrl: '/assets/AngularJS/Artist/views/modalMusic.html.haml',
      controller: 'ModalInstanceCtrl',
      resolve: {
      	influences: function() {
      		return $scope.influences;
      	}
      }
    });

    modalInstance.result.then(function (music) {
    	$scope.noLinkMusics.push(music);
    }, function () {
      console.log('Modal dismissed at: ' + new Date());
    });
  };
}]);

SoonzikArtistApp.controller('ModalInstanceCtrl', ["$scope", "$modalInstance", "Upload", "HTTPService", "influences", function ($scope, $modalInstance, Upload, HTTPService, influences) {
	$scope.music = null;
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

  $scope.ok = function () {
  	var parameters = { music: $scope.form, genres: $scope.selected.selectedGenres };
  	HTTPService.uploadMusic($scope.file, parameters, function (evt) {
			$scope.loading = true;
		}, function (data, status, headers, config) {
			$scope.loading = false;
			$modalInstance.close(data.music);
		}, function (error) {
			$scope.loading = false;
			console.log(error);
		});
  };

  $scope.cancel = function () {
    $modalInstance.dismiss('cancel');
  };

  $scope.uploadMusic = function($file) {
  	if ($file && $file.length) {
			for (var i = 0; i < $file.length; i++) {
				var file = $file[i];

				$scope.file = file;
			}
    }
	}
}]);