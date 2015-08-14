SoonzikApp.controller('HeaderCtrl', ['$scope', "$routeParams", "$location", "SecureAuth", "HTTPService", "$timeout", "NotificationService", function ($scope, $routeParams, $location, SecureAuth, HTTPService, $timeout, NotificationService) {

	$scope.menuOpen = false;
	$scope.search = {
		value: ""
	};
	$scope.user = false;
	$scope.tweets = [];
	$scope.notifs = [];

	$scope.initHeader = function() {
		$("#inputSearch").keydown(function (t) {
			if (event.keyCode == 13) {
				$scope.sendSearch();
			}
		});

		$scope.$on('user:changeImg', function(event, data) {
			$("#profilePicture").attr("src", "/assets/usersImage/avatars/" + data.url)
		});

		var current_user = SecureAuth.getCurrentUser();
		if (current_user.id != null && current_user.token != null && current_user.username != null) {
			$scope.user = current_user;

			SecureAuth.securedTransaction(function (key, user_id) {
				var params = [
					{ key: "user_id", value: user_id },
					{ key: "secureKey", value: key },
					{ key: "limit", value: 10 }
				];
				HTTPService.findNotif(params).then(function(response) {
					$scope.notifs = response.data.content;
				}, function(error) {
					NotificationService.error("Can't load your notification");
				});
			}, function(error) {
				NotificationService.error("Can't load your notification");
			});
			notifTweet(true);
		}
	}

	$scope.switchMenu = function() {
		$scope.menuOpen = !$scope.menuOpen;
	}

	$scope.sendSearch = function() {
		$location.path('/search/' + encodeURIComponent($scope.search.value));
	}

	$scope.closeMenu = function() {
		$scope.menuOpen = false;
	}

	var notifTweet = function(firstLoop) {
		var paramsTweet = [
			{ key: encodeURIComponent("attribute[msg]"), value: encodeURIComponent("%" + $scope.user.username + "%") },
			{ key: encodeURIComponent("order_by_desc[]"), value: encodeURIComponent("created_at") }
		];

		HTTPService.findTweet(paramsTweet).then(function(response) {
			tmp_tweets = response.data.content;


			// Loop backward to splice inside
			for (var i = tmp_tweets.length - 1 ; i >= 0 ; i--) {
				if (tmp_tweets[i].user.id == $scope.user.id) {
					tmp_tweets.splice(i, 1);
				}
			}

			if (firstLoop == true) {
				$scope.tweets = tmp_tweets;

				$timeout(function() {
					notifTweet(false);
				}, 10000);
			} else {
				var newTweets = [];
				if ($scope.tweets.length == 0) {
					newTweets = tmp_tweets;
				} else {
					var limit = 0
					for (var i = 0 ; i < tmp_tweets.length ; i++) {
						if (tmp_tweets[i].id == $scope.tweets[0].id) {
							limit = i;
						}
					}
					newTweets = tmp_tweets.splice(0, limit);
				}
				$scope.tweets = newTweets.concat($scope.tweets);

				for (var i = 0 ; i < newTweets.length ; i++) {
					NotificationService.info("New tweet from " + newTweets[i].user.username);
				}
			}
		}, function(error) {
			// Do nothing
		});
	}

}]);