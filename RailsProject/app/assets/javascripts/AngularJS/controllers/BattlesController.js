SoonzikApp.controller('BattlesCtrl', ['$scope', "$routeParams", 'SecureAuth', 'HTTPService', 'NotificationService', function ($scope, $routeParams, SecureAuth, HTTPService, NotificationService) {
	$scope.loading = true;
	$scope.index = { battles: [], votes: [] };
	$scope.show = {};

	var BattlePerPage = 10;

	$scope.indexInit = function() {
		$scope.index.currentPage = (toInt($routeParams.page) == 0 ? 1 : toInt($routeParams.page));
		
		var parameters = [
			{ key: "limit", value: BattlePerPage },
			{ key: "offset", value: (($scope.index.currentPage - 1) * BattlePerPage) },
			{ key: "order_by_desc[]", value: "created_at" }
		];
		
		HTTPService.indexBattles([{ key: "count", value: "true" }]).then(function(response) {
			var numberResults = response.data.content;

			if (typeof numberResults != "undefined") {
				$scope.index.numberPages = ~~(numberResults / BattlePerPage) + 1;
			} else {
				$scope.index.numberPages = 1;
			}

			HTTPService.findBattles(parameters).then(function(response) {
				$scope.index.battles = response.data.content;

				// For each battles
				for (var battleIndex in $scope.index.battles) {
					var votes = [
						{ value: 0, label: $scope.index.battles[battleIndex].artist_one.username },
						{ value: 0, label: $scope.index.battles[battleIndex].artist_two.username }
					];

					// For each votes
					for (var voteIndex in $scope.index.battles[battleIndex].votes) {
						if ($scope.index.battles[battleIndex].votes[voteIndex].artist_id == $scope.index.battles[battleIndex].artist_one.id) {
							votes[0].value++;
						} else if ($scope.index.battles[battleIndex].votes[voteIndex].artist_id == $scope.index.battles[battleIndex].artist_two.id) {
							votes[1].value++;
						}
					}
					if (votes[0].value == 0 && votes[1].value == 0) {
						$scope.index.votes[$scope.index.battles[battleIndex].id] = [];
					} else {
						$scope.index.votes[$scope.index.battles[battleIndex].id] = votes;
					}
				}

				$scope.loading = false;
			}, function(error) {
				console.log(error);
			});
		}, function(error) {
			console.log(error);
		});

		
	}

	/* Utils function */

	$scope.range = function(n) {
  	return new Array(n);
  }

  $scope.min = function(a, b) {
  	return (a < b ? a : b);
  }

  $scope.max = function(a, b) {
  	return (a > b ? a : b);
  }

	var toInt = function(value) {
		var number = parseInt(value);
		if (isNaN(number)) {
			return 0;
		} else {
			return number;
		}
	}
}]);