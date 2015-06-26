SoonzikArtistApp.controller('MusicCtrl', ['$scope', 'SecureAuth', 'HTTPService', 'NotificationService', '$timeout', '$modal', function ($scope, SecureAuth, HTTPService, NotificationService, $timeout, $modal) {

	$scope.loading = true;
	$scope.albums = [];
	$scope.noLinkMusics = [];
	$scope.user = false;
	$scope.genres = [];

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

				HTTPService.indexGenre().then(function(response) {
					$scope.genres = response.data.content;
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

	// For the modal
	$scope.open = function () {
    var modalInstance = $modal.open({
      templateUrl: '/assets/AngularJS/Artist/views/modalMusic.html.haml',
      controller: 'ModalInstanceCtrl',
      resolve: {
      	genres: function() {
      		return $scope.genres;
      	}
      }
    });

    modalInstance.result.then(function (music) {
    	$scope.noLinkMusics(music);
    }, function () {
      console.log('Modal dismissed at: ' + new Date());
    });
  };
}]);

SoonzikArtistApp.controller('ModalInstanceCtrl', ["$scope", "$modalInstance", "Upload", "HTTPService", "genres", function ($scope, $modalInstance, Upload, HTTPService, genres) {
	$scope.music = null;
	$scope.file = null;
	$scope.form = {
		title: "",
		price: 0,
		limited: "true"
	};
	$scope.genres = genres;
	$scope.selected = {
		selectedGenres: []
	}

  $scope.ok = function () {
  	HTTPService.uploadMusic($scope.file, { music: $scope.form }, function (evt) {
			var progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
		}, function (data, status, headers, config) {
			$modalInstance.close(data.music);
		}, function (error) {
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