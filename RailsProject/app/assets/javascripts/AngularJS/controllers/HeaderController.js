SoonzikApp.controller('HeaderCtrl', ['$scope', "$routeParams", "$location", function ($scope, $routeParams, $location) {

	$scope.menuOpen = false;
	$scope.search = {
		value: ""
	}

	$scope.initHeader = function() {
		$("#inputSearch").keydown(function (t) {
			if (event.keyCode == 13) {
				$scope.sendSearch();
			}
		});

		$scope.$on('user:changeImg', function(event, data) {
			$("#profilePicture").attr("src", "/assets/usersImage/avatars/" + data.url)
		});
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

}]);