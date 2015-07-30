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
	}

	$scope.switchMenu = function() {
		$scope.menuOpen = !$scope.menuOpen;
	}

	$scope.sendSearch = function() {
		$location.path('/search/' + encodeURIComponent($scope.search.value));
	}

}]);