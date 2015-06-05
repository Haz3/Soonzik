SoonzikApp.controller("PlayerCtrl", ["$scope", "$rootScope", "HTTPService", "NotificationService", "SecureAuth", function ($scope, $rootScope, HTTPService, NotificationService, SecureAuth) {

  var activeUrl = null;
  $scope.user = false;

  $scope.loaded = false;
  $scope.loading = true;

  $scope.paused = true;
  $scope.shuffle = false;
  $scope.volume = 1.0;
  $scope.oldvolume = 0.0;

  $scope.time = 0;
  $scope.timeFormated = "";

  $scope.playlist = [];
  $scope.indexPlaylist = 0;

  $scope.myPlaylists = [];

  $scope.infomusic = { current: false, playlist: false };
  $scope.toDelete = false;
  $scope.toRead = false;

  function n(n){
    return n > 9 ? "" + n: "0" + n;
  }

  function updateTime() {
    var val = Math.round($scope.wavesurfer.getCurrentTime(), 0);
    if (val != $scope.time) {
      $scope.time = val;
      var duration = Math.round($scope.wavesurfer.getDuration(), 0);
      $scope.timeFormated = $scope.formatedDuration(val) + "/" + $scope.formatedDuration(duration);
      if ($scope.$root.$$phase != '$apply' && $scope.$root.$$phase != '$digest') {
        $scope.$apply();
      }
    }
  }

  $scope.initPlayer = function() {
  	var current_user = SecureAuth.getCurrentUser();
		if (current_user.id != null && current_user.token != null && current_user.username != null) {
			$scope.user = current_user;
		}

  	$("#sliderVolume").slider({
      orientation: "vertical",
      range: "min",
      min: 0,
      max: 100,
      value: 100,
      slide: function( event, ui ) {
        $scope.volume = ui.value / 100;
        $scope.wavesurfer.setVolume($scope.volume);
        $scope.$apply();
      }
    });

    $(window).resize(resizeHiddenPlaylist);
    resizeHiddenPlaylist();

    if ($scope.user != false) {
	    HTTPService.findPlaylist([{ key: "attribute[user_id]", value: $scope.user.id }]).then(function(response) {
	    	$scope.myPlaylists = response.data.content;
	    	for (var i in $scope.myPlaylists) {
	    		$scope.myPlaylists[i].extend = false;
	    		$scope.myPlaylists[i].share = false;
	    		$scope.myPlaylists[i].url = 'http://lvh.me:3000/playlists/' + $scope.myPlaylists[i].id;

	    		var duration = 0;
	    		for (var j = 0 ; j < $scope.myPlaylists[i].musics.length ; j++) {
	    			duration += $scope.myPlaylists[i].musics[j].duration;
	    		}

	    		$scope.myPlaylists[i].duration = duration;

	    	}
  			$scope.loading = false;
	    }, function(error) {
	    	NotificationService.error("Error : Can't get your playlist");
	    });
  	}
  }

  $scope.$on('player:play', function(event, data) {
    var dataObject = { title: data.song.title, id: data.song.id, obj: data.song };
    $scope.loaded = false;
    
    var inArray = isInPlaylist(dataObject);

    if (inArray !== false) {
    	$scope.indexPlaylist = inArray;
    } else {
    	$scope.playlist.push(dataObject);
    	$scope.indexPlaylist = $scope.playlist.length - 1;
    }
    
    if ($scope.user != false) {
    	SecureAuth.securedTransaction(function(key, user_id) {
    		$scope.play(HTTPService.getMP3musicURL(dataObject.id, [{ key: "user_id", value: user_id}, { key: "secureKey", value: key }]));
    	}, function(error) {
    		NotificationService.error("Error while loading the music : " + dataObject.title);
    	});
    } else {
    	$scope.play(HTTPService.getMP3musicURL(dataObject.id, null));
    }
  });

  $scope.$on('wavesurferInit', function (e, wavesurfer) {
	  $scope.wavesurfer = wavesurfer;

	  $scope.wavesurfer.on('play', function () {
      $scope.paused = false;
	  });

	  $scope.wavesurfer.on('pause', function () {
      $scope.paused = true;
	  });

	  $scope.wavesurfer.on('finish', function () {
	  	$scope.indexPlaylist++;
	  	if (($scope.indexPlaylist == $scope.playlist.length && $scope.shuffle == false) ||
	  		($scope.shuffle == true && $scope.playlist.length <= 1)) {
	      $scope.paused = true;
	      $scope.wavesurfer.seekTo(0);
	      $scope.timeFormated = "";
	  	} else {
	  		if ($scope.shuffle == true) {
		  		var nextTrack = 0;
		  		do
		  			nextTrack = Math.abs(Math.random() * ($scope.playlist.length - 1))
		  		while (nextTrack != $scope.indexPlaylist - 1);
		  		$scope.indexPlaylist = nextTrack;
	  		}

		    if ($scope.user != false) {
		    	SecureAuth.securedTransaction(function(key, user_id) {
		    		$scope.play(HTTPService.getMP3musicURL($scope.playlist[$scope.indexPlaylist].id, [{ key: "user_id", value: user_id}, { key: "secureKey", value: key }]));
		    	}, function(error) {
		    		NotificationService.error("Error while loading the music : " + $scope.playlist[$scope.indexPlaylist].title);
		    	});
		    } else {
		    	$scope.play(HTTPService.getMP3musicURL($scope.playlist[$scope.indexPlaylist].id, null));
		    }
	  	}
      $scope.$apply();
	  });

	  $scope.wavesurfer.on('audioprocess', updateTime);
	  $scope.wavesurfer.on('seek', updateTime);
	  $scope.wavesurfer.on('ready', function () {
      $scope.loaded = true;
      updateTime();
      $scope.wavesurfer.play();
	  });

  });

  $scope.play = function (url) {
    if (!$scope.wavesurfer) {
      return;
    }
    activeUrl = url;

    $scope.wavesurfer.load(activeUrl);
  };

  $scope.isPlaying = function (url) {
    return url == activeUrl;
  };

  $scope.isVolumeOn = function() {
  	var value = $scope.volume * 100;

  	if (parseInt(value) == 0)
  		return false;
  	return true;
  }

  $scope.displayPlaylist = function() {
  	if ($("#currentPlaylist").css("right") != "0px") {
	  	$("#currentPlaylist").css("right", 0);
  	} else {
	  	$("#currentPlaylist").css("right", -$("#currentPlaylist").width() - 100);
	  	$scope.toRead = false;
	  	unshareEverything();
  	}
  }

  $scope.cleanPlaylist = function() {
	  $scope.playlist = [];
  	$scope.indexPlaylist = 0;
  }

  $scope.removeMusicFromPlaylist = function(index) {
	  $scope.playlist.splice(index, 1);
	  if (($scope.indexPlaylist == $scope.playlist.length && $scope.shuffle == false) ||
  		($scope.shuffle == true && $scope.playlist.length <= 1)) {
      $scope.paused = true;
      $scope.wavesurfer.seekTo(0);
      $scope.timeFormated = "";
      $scope.pausePlayer();
  	} else {
  		if ($scope.shuffle == true) {
	  		var nextTrack = 0;
	  		do
	  			nextTrack = Math.abs(Math.random() * ($scope.playlist.length - 1))
	  		while (nextTrack != $scope.indexPlaylist - 1);
	  		$scope.indexPlaylist = nextTrack;
  		}

	    if ($scope.user != false) {
	    	SecureAuth.securedTransaction(function(key, user_id) {
	    		$scope.play(HTTPService.getMP3musicURL($scope.playlist[$scope.indexPlaylist].id, [{ key: "user_id", value: user_id}, { key: "secureKey", value: key }]));
	    	}, function(error) {
	    		NotificationService.error("Error while loading the music : " + $scope.playlist[$scope.indexPlaylist].title);
	    	});
	    } else {
	    	$scope.play(HTTPService.getMP3musicURL($scope.playlist[$scope.indexPlaylist].id, null));
	    }
  	}
  }

  var isInPlaylist = function(compareObject) {
  	for (var i = 0 ; i < $scope.playlist.length ; i++) {
  		if (compareObject.id == $scope.playlist[i].id)
  			return i;
  	}
  	return false;
  }

  var resizeHiddenPlaylist = function() {
  	var height = $(window).height();
  	var width = $(window).width();

  	$("#currentPlaylist").width(width);
  	$("#currentPlaylist").height(height - 60);

  	if ($("#currentPlaylist").css("right") != "0px") {
	  	$("#currentPlaylist").css("right", -$("#currentPlaylist").width() - 100);
  	}
  }

  $scope.pausePlayer = function() {
  	if ($scope.loaded && $scope.wavesurfer) {
  		if ($scope.paused == true && $scope.wavesurfer.getCurrentTime() == 0) {
  			$scope.playFromPlaylist($scope.indexPlaylist);
  		} else {
  			$scope.wavesurfer.playPause();
  		}
  	}
  }

  $scope.playFromPlaylist = function(index) {
  	$scope.indexPlaylist = index;
  	if ($scope.user != false) {
    	SecureAuth.securedTransaction(function(key, user_id) {
    		$scope.play(HTTPService.getMP3musicURL($scope.playlist[$scope.indexPlaylist].id, [{ key: "user_id", value: user_id}, { key: "secureKey", value: key }]));
    	}, function(error) {
    		NotificationService.error("Error while loading the music : " + $scope.playlist[$scope.indexPlaylist].title);
    	});
    } else {
    	$scope.play(HTTPService.getMP3musicURL($scope.playlist[$scope.indexPlaylist].id, null));
    }
  }

  $scope.formatedDuration = function(duration) {
    var minutes = Math.floor(duration / 60);
    var seconds = duration - minutes * 60;
    return n(minutes) + ":" + n(seconds);
  }

  $scope.removePlaylist = function(playlist) {
  	SecureAuth.securedTransaction(function(key, user_id) {
  		var params = [
  			{ key: "id", value: playlist.id},
  			{ key: "user_id", value: user_id},
  			{ key: "secureKey", value: key }
  		];
  		HTTPService.destroyPlaylist(params).then(function() {
  			for (var indexOfMyPlaylist in $scope.myPlaylists) {
  				if ($scope.myPlaylists[indexOfMyPlaylist].id == playlist.id) {
  					$scope.myPlaylists.splice(indexOfMyPlaylist, 1);
  					break;
  				}
  			}
  		}, function(error) {
  			NotificationService.error("Error while deleting the playlist : " + playlist.name);
  		});
  	}, function(error) {
  		NotificationService.error("Error while deleting the playlist : " + playlist.name);
  	});
  }

  $scope.infoForMusic = function(music, panel) {
  	if (panel == "current") {
  		$scope.infomusic.current = music;
  	} else {
  		$scope.infomusic.playlist = music;
  	}
  }

  $scope.addToCurrentPlaylist = function(playlist) {
  	for (var i = 0 ; i < playlist.length ; i++) {
  		var isIn = false;
  		for (var j = 0 ; j < $scope.playlist.length ; j++) {
  			if ($scope.playlist[j].obj.id == playlist[i].id) { isIn = true; }
  		}
  		if (!isIn) {
  			$scope.playlist.push({ title: playlist[i].title, id: playlist[i].id, obj: playlist[i] });
  		}
  	}
  	return false;
  }

  $scope.replaceToCurrentPlaylist = function(playlist) {
  	var paused = $scope.paused;
  	$scope.wavesurfer.stop();
	  $scope.wavesurfer.seekTo(0);
  	$scope.wavesurfer.load("");
  	$scope.wavesurfer.empty();
  	$scope.playlist = [];
  	for (var i = 0 ; i < playlist.length ; i++) {
  		$scope.playlist.push({ title: playlist[i].title, id: playlist[i].id, obj: playlist[i] });
  	}
  	$scope.indexPlaylist = 0;
  	if (paused == false) {
  		$scope.playFromPlaylist(0);
  	}
  	return false;
  }

  $scope.removeFromPlaylist = function(music, playlist) {
  	SecureAuth.securedTransaction(function(key, user_id) {
  		var parameters = [
  			{ key: "id", value: music.id},
  			{ key: "playlist_id", value: playlist.id},
  			{ key: "user_id", value: user_id},
  			{ key: "secureKey", value: key }
  		];
  		HTTPService.deleteFromPlaylist(parameters).then(function() {
  			for (var i = 0 ; i < playlist.musics.length ; i++) {
  				if (playlist.musics[i].id == music.id) {
  					playlist.musics.splice(i, 1);
  					break;
  				}
  			}
  		}, function(error) {
  			NotificationService.error("Error while deleting the music from the playlist");
  		});
  	}, function(error) {
  		NotificationService.error("Error while deleting the music from the playlist");
  	})
  }

  $scope.unshare = function(myplaylist) {
  	myplaylist.share = false;
  }

  $scope.readInfo = function(value) {
  	$scope.toRead = value;
  }

  var unshareEverything = function() {
  	for (var i = 0 ; i < $scope.myPlaylists.length ; i++) {
  		$scope.unshare($scope.myPlaylists[i]);
  	}
  }
}]);