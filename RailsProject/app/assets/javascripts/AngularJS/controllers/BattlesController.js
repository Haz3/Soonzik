SoonzikApp.controller('BattlesCtrl', ['$scope', "$routeParams", 'SecureAuth', 'HTTPService', 'NotificationService', function ($scope, $routeParams, SecureAuth, HTTPService, NotificationService) {
	$scope.loading = true;
	$scope.index = {};
	$scope.show = {};

	var BattlePerPage = 10;

	$scope.indexInit = function() {
		$scope.index.currentPage = (toInt($routeParams.page) == 0 ? 1 : toInt($routeParams.page));
		
		var parameters = [
			{ key: "limit", value: BattlePerPage },
			{ key: "offset", value: (($scope.index.currentPage - 1) * BattlePerPage) },
			{ key: "order_by_desc[]", value: "created_at" }
		];
		
		HTTPService.findBattles(parameters).then(function(response) {
			$scope.index.battles = response.data.content;
			$scope.loading = false;
		}, function(error) {
			console.log(error);
		});
	}

	/* Utils function */

	$scope.range = function(n) {
  	return new Array(n);
  };

  $scope.min = function(a, b) {
  	return (a < b ? a : b);
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