SoonzikApp.controller('PacksCtrl', ['$scope', 'SecureAuth', 'HTTPService', function ($scope, SecureAuth, HTTPService) {

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
			console.log($scope.packs);

		}, function (error) {
			console.log("No Packs Available");
		});

		$scope.showPack = true;
	
	}

	$scope.showPacksById = function() {
		var parameters = [
			{key: "id", value: 1}
		];

		HTTPService.showPacks(parameters).then(function(packId) {
			$scope.thisPack = packId.data.content;
			console.log($scope.thisPack);

		}, function (error) {
			console.log("This pack doesn't exist");
		});
	}
}]);