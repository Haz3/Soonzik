SoonzikArtistApp.controller('HomeCtrl', ['$scope', 'SecureAuth', 'HTTPService', 'NotificationService', '$timeout', function ($scope, SecureAuth, HTTPService, NotificationService, $timeout) {
	$scope.loading = {
		music: true,
		album: true,
		pack: true,
		note: true,
		battle: true
	};

	$scope.values = {
		music: {
			data: [
				{ music_title: "undefined", total_sell: 0, lastweek: 0 }
			],
			xkey: "music_title",
			ykeys: ["total_sell", "lastweek"],
			labels: ["Sell (total) ", "Sell number last week (total) "]
		},
		album: {
			data: [
				{ album_title: "undefined", total_sell: 0, lastweek: 0 }
			],
			xkey: "album_title",
			ykeys: ["total_sell", "lastweek"],
			labels: ["Sell (total) ", "Sell number last week (total) "]
		},
		pack: {
			data: [
				{ x: "Pack 1", week: 55, lastweek: 30 },
				{ x: "Pack 2", week: 45, lastweek: 40 },
				{ x: "Pack 3", week: 65, lastweek: 50 },
				{ x: "Pack 4", week: 42, lastweek: 0 }
			],
			xkey: "x",
			ykeys: ["week", "lastweek"],
			labels: ["Sell (total) ", "Sell number last week (total) "]
		}
	}

	$scope.initHome = function() {
		$timeout(function() {
			HTTPService.getStats().then(function(response) {
				$scope.values.music.data = response.data.music;
				$scope.values.album.data = response.data.album;
				$scope.loading.music = false;
				$scope.loading.album = false;
			}, function(error) {
				NotificationService.error("Error while loading statistics. Try again later.");
			});
			$timeout(function() {
				$scope.loading.pack = false;
			}, 3000);
		}, 3000);
	}
}]);