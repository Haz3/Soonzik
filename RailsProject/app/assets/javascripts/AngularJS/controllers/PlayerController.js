SoonzikApp.controller("PlayerCtrl", ["$scope", "$rootScope", function ($scope, $rootScope) {

  var activeUrl = null;

  $scope.loaded = false;

  $scope.paused = true;
  $scope.shuffle = false;
  $scope.volume = 1.0;
  $scope.oldvolume = 0.0;

  $scope.time = 0;
  $scope.timeFormated = "";

  $scope.playlist = [];
  $scope.indexPlaylist = 0;

  function n(n){
    return n > 9 ? "" + n: "0" + n;
  }

  function updateTime() {
    var val = Math.round($scope.wavesurfer.getCurrentTime(), 0);
    if (val != $scope.time) {
      $scope.time = val;
      var duration = Math.round($scope.wavesurfer.getDuration(), 0);
      var currentMinutes = Math.floor(val / 60);
      var currentSeconds = val - currentMinutes * 60;
      var totalMinutes = Math.floor(duration / 60);
      var totalSeconds = duration - totalMinutes * 60;
      $scope.timeFormated = n(currentMinutes) + ":" + n(currentSeconds) + "/" + n(totalMinutes) + ":" + n(totalSeconds);
      if ($scope.$root.$$phase != '$apply' && $scope.$root.$$phase != '$digest') {
        $scope.$apply();
      }
    }
  }

  $scope.initPlayer = function() {
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
  }

  $scope.$on('player:play', function(event, data) {
    $scope.loaded = false;
    data = "/assets/" + data.artist + "/" + data.song.file + ".mp3";
    if ($.inArray(data, $scope.playlist) > -1) {
    	$scope.indexPlaylist = $.inArray(data, $scope.playlist);
    } else {
    	$scope.playlist.push(data);
    	$scope.indexPlaylist = $scope.playlist.length - 1;
    }
    $scope.play(data);
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
	  	} else {
	  		if ($scope.shuffle == true) {
		  		var nextTrack = 0;
		  		do
		  			nextTrack = Math.abs(Math.random() * ($scope.playlist.length - 1))
		  		while (nextTrack != $scope.indexPlaylist - 1);
		  		$scope.indexPlaylist = nextTrack;
	  		}
		    $scope.play($scope.playlist[$scope.indexPlaylist]);
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

}]);