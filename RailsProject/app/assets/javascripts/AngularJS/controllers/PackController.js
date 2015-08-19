SoonzikApp.controller('PacksCtrl', ['$scope', '$routeParams', 'SecureAuth', 'HTTPService', function ($scope, $routeParams, SecureAuth, HTTPService) {

	$scope.loading = true;

	$scope.initFoundation = function () {
		$(document).foundation();
	}

	$scope.showPacks = function() {
		var parameters = [
			{ key: "limit", value: 4 },
			{ key: "order_by_desc[]", value: "created_at" }
		];

		HTTPService.findPacks(parameters).then(function(packs) {
			
			$scope.pack = packs.data.content;

		}, function (error) {
			console.log("No Packs Available");
		});

		$scope.Pack = true;
	
	}

	$scope.showPacksById = function() {
		var id = $routeParams.id;

		HTTPService.showPack(id).then(function(response) {
			$scope.thisPack = response.data.content;
			
			console.log($scope.thisPack);

		}, function (error) {
			console.log("This pack doesn't exist");
		});

		$scope.thisPackId = true;
	
	}

	$scope.timeLeft = function() {
		var begin = $scope.pack.begin_date;
		var end = $scope.pack.end_date;
		
		console.log("begin --> " + $begin);
		console.log("end --> " + $end);
	}

	$scope.loading = false;

}]);