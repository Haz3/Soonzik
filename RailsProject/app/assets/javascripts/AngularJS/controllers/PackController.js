SoonzikApp.controller('PacksCtrl', ['$scope', '$routeParams', 'SecureAuth', 'HTTPService', 'NotificationService', function ($scope, $routeParams, SecureAuth, HTTPService, NotificationService) {

	$scope.loading = true;
	$scope.saveCart = [];

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

	$scope.managePrice = function () {

		console.log("managePrice");
		
		$scope.priceMini = 20;

		$scope.artistPercentage = (($scope.priceMini * 65) / 100)
		$scope.associationPercentage = (($scope.priceMini * 20) / 100);
		$scope.websitePercentage = (($scope.priceMini * 15) / 100);

		console.log(artistPercentage);
	}

	$scope.timeLeft = function() {
		var begin = $scope.pack.begin_date;
		var end = $scope.pack.end_date;
		
	}

	$scope.addToCart = function() {
		SecureAuth.securedTransaction(function(key, id) {
			var parameters =
		  		{	secureKey: key,
		  			user_id : id,
			  		pack_id: $scope.thisPack.id,
			  		amount: $scope.thisPack.minimal_price,
			  		artist : $scope.artistPercentage,
			  		association : $scope.associationPercentage,
			  		website : $scope.websitePercentage
			  	};
/*
			HTTPService.(parameters).then(function(response) {
				$scope.saveCart.push(response.data.content);
			
			}, function(error) {
				NotificationService.error("Error while saving your cart, please try later");
			});
*/
		}, function(error) {
			NotificationService.error("Error while saving your cart, are you connected ?");
		});
	}

	$scope.loading = false;

}]);