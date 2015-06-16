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
		},
		note_musics: {
			data: [
				{ music_title: "undefined", total_sell: 0, lastweek: 0 }
			],
			xkey: "album_title",
			ykeys: ["total_sell", "lastweek"],
			labels: ["Sell (total) ", "Sell of last week (total) "]
		},
		note_musics: {
			data: [
				{ music_title: "undefined", note: 0, album_average: 0 }
			],
			xkey: "music_title",
			ykeys: ["note", "album_average"],
			labels: ["Note (average) ", "Note of all the tracks of the albums (average) "]
		},
		note_albums: {
			data: [
				{ album_title: "undefined", note: 0 }
			],
			xkey: "album_title",
			ykeys: ["note"],
			labels: ["Note (average) "]
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
				$scope.loading.pack = false;

				// To format informations for the line chart
				data_music_notes = [];
				for (var i = 0 ; i < response.data.notes.album.length ; i++) {
					for (var j = 0 ; j < response.data.notes.album[i].musics.length ; j++) {
						if (j == 0) {
							data_music_notes.push({
								music_title: response.data.notes.album[i].musics[j].name,
								note: response.data.notes.album[i].musics[j].note,
								album_average: response.data.notes.album[i].average
							});
						} else {
							data_music_notes.push({
								music_title: response.data.notes.album[i].musics[j].name,
								note: response.data.notes.album[i].musics[j].note
							});
						}
					}
				}
				$scope.values.note_musics.data = data_music_notes;

				// To format informations for the line chart
				data_album_notes = [];
				if (response.data.notes.album.length > 0) {
					data_album_notes.push({
						album_title: "All albums",
						note: response.data.notes.average
					});
				}
				for (var i = 0 ; i < response.data.notes.album.length ; i++) {
					data_album_notes.push({
						album_title: response.data.notes.album[i].name,
						note: response.data.notes.album[i].average
					});
				}
				$scope.values.note_albums.data = data_album_notes;
				$scope.loading.note = false;
			}, function(error) {
				NotificationService.error("Error while loading statistics. Try again later.");
			});
		}, 3000);
	}
}]);