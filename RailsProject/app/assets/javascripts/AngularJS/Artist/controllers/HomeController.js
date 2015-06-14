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
			labels: ["Sell (total) ", "Sell of last week (total) "]
		},
		album: {
			data: [
				{ album_title: "undefined", total_sell: 0, lastweek: 0 }
			],
			xkey: "album_title",
			ykeys: ["total_sell", "lastweek"],
			labels: ["Sell (total) ", "Sell of last week (total) "]
		},
		pack: {
			data: [
				{ pack_title: "undefined", total_sell: 0, total_sell_partial: 0, lastweek: 0, lastweek_partial: 0 }
			],
			xkey: "pack_title",
			ykeys: ["total_sell", "total_sell_partial", "lastweek", "lastweek_partial"],
			labels: ["Sell (total) ", "Sell partial bundle (total) ", "Sell of last week (total) ", "Sell of partial bundle last week (total) "]
		}
	}

	$scope.initHome = function() {
		$timeout(function() {
			HTTPService.getStats().then(function(response) {
				$scope.values.music.data = response.data.music;
				$scope.values.album.data = response.data.album;
				$scope.values.pack.data = response.data.pack;
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