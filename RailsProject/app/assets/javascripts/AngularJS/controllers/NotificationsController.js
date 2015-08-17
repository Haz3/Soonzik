SoonzikApp.controller('NotifsCtrl', ['$scope', 'SecureAuth', 'HTTPService', 'NotificationService', '$timeout', '$rootScope', function ($scope, SecureAuth, HTTPService, NotificationService, $timeout, $rootScope) {
	$scope.loading = true;
	$scope.receive = false;
	$scope.notifications = [];
	$scope.loadingNewNotifs = false;

	$scope.notifInit = function() {
		// ask the header controller how many notification are new
		$scope.$on('notif:getNews', function(event, data) {
			$scope.notifications = JSON.parse(JSON.stringify(data));
			for (var i = 0 ; i < data.length ; i++) {
				$scope.r_markAsRead(i, data);
			}

			if ($scope.loading == true) {
				$scope.getMoreNotifications($scope.notifications.length);
			}

			$scope.loading = false;
			$scope.receive = true;
		});

		$scope.$on('notif:new', function(event, data) {
			$scope.notifications = data.concat($scope.notifications);
			for (var i = 0 ; i < data.length ; i++) {
				$scope.r_markAsRead(i, data);
			}
		});
		
		$scope.broadcastNotifQuestion();
	}

	$scope.broadcastNotifQuestion = function() {
		if ($scope.receive == false) {
			$rootScope.$broadcast('notif:askNew');
			$timeout($scope.broadcastNotifQuestion, 3000);
		}
	}

	$scope.createContent = function(notif) {
		if (notif.notif_type == "tweet") {
			return notif.from.username + " has tweeted something to you";
		} else if (notif.notif_type == "friend") {
			return notif.from.username + " has added you as friend";
		} else {
			return notif.from.username + " follow you";
		}
	}

	$scope.r_markAsRead = function(index, data) {
		SecureAuth.securedTransaction(function(key, user_id) {
			HTTPService.readNotif(data[index].id, { secureKey: key, user_id: user_id }).then(function(response) {
				$rootScope.$broadcast('notif:read', data[index].id);
			}, function(error) {
				NotificationService.error("Can't mark your notification as read");
			});
		}, function(error) {
			NotificationService.error("Can't mark your notification as read");
		});
	}

	$scope.getMoreNotifications = function(offset) {
		if ($scope.loadingNewNotifs == false) {
			$scope.loadingNewNotifs = true
			SecureAuth.securedTransaction(function (key, user_id) {
				var params = [
					{ key: "user_id", value: user_id },
					{ key: "secureKey", value: key },
					{ key: "offset", value: offset },
					{ key: "limit", value: 10 }
				];
				HTTPService.findNotif(params).then(function(response) {
					$scope.notifications = $scope.notifications.concat(response.data.content);
					$scope.loadingNewNotifs = false;
				}, function(error) {
					NotificationService.error("An error occured, can't get more notifications. Try Later.");
				});
			});
		}
	}
}]);