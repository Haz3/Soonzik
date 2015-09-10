SoonzikApp.controller('FriendCtrl', ['$scope', 'SecureAuth', 'HTTPService', 'NotificationService', "$rootScope", function ($scope, SecureAuth, HTTPService, NotificationService, $rootScope) {

$scope.loading = true;

	$scope.initFoundation = function () {
		$(document).foundation();
	}

	$scope.showFriends = function() {
		var current_user = SecureAuth.getCurrentUser();

		HTTPService.getFriends(current_user.id).then(function(response) {
			
			$scope.friends = response.data.content;
			console.log($scope.friends);

		}, function (error) {
			console.log($rootScope.labels.FILE_FRIEND_LOAD_FRIENDS_ERROR_MESSAGE);
		});

		$scope.Friend = true;
	}
	$scope.loading = false;

}]);
