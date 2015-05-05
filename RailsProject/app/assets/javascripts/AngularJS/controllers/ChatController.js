SoonzikApp.controller('ChatCtrl', ['$scope', 'SecureAuth', 'HTTPService', function ($scope, SecureAuth, HTTPService) {
	$scope.current_user = SecureAuth.getCurrentUser();
	$scope.friends = [];

	$scope.open_chat = function(friend) {
		console.log(friend);
	}

	var init = function() {
		HTTPService.getProfile($scope.current_user.id).then(function(profile) {
			$scope.friends = profile.data.content.friends;
		}, function(error) {
			console.log(error);
		});
	}

	init();
}]);