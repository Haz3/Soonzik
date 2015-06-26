SoonzikApp.controller('FriendCtrl', ['$scope', "$routeParams", 'SecureAuth', 'HTTPService', 'NotificationService', function ($scope, $routeParams, SecureAuth, HTTPService, NotificationService) {

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
			console.log("No friends available");
		});

		$scope.Friend = true;
	}
	$scope.loading = false;

}]);