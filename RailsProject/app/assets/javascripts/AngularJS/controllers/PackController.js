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
			console.log($rootScope.labels.FILE_PACK_LOAD_ERROR_MESSAGE);
		});

		$scope.Pack = true;
	
	}

	$scope.showPacksById = function() {
		var id = $routeParams.id;

		$scope.percentages = [
			{ value: 65, label: "Artiste" },
			{ value: 20, label: "Association" },
			{ value: 15, label: "website" }
		];

		HTTPService.showPack(id).then(function(response) {

			$scope.thisPack = response.data.content;
			$scope.end_date = $scope.thisPack.end_date;

		}, function (error) {
			console.log($rootScope.labels.FILE_PACK_LOAD_ONE_PACK_ERROR_MESSAGE);
		});

		$scope.thisPackId = true;
	
	}

	$scope.managePrice = function () {

		$scope.priceMini = 20;

		$scope.artistPercentage = (($scope.priceMini * 65) / 100);
		$scope.associationPercentage = (($scope.priceMini * 20) / 100);
		$scope.websitePercentage = (($scope.priceMini * 15) / 100);
	}

	$scope.timeLeft = function() {
		var now = new Date();
		var end = new Date($scope.end_date);

		console.log(now);
		console.log(end);

		if (end > now) {
			$scope.timeLeftPack = "Terminé";
		} else {
			$scope.timeLeftPack = end - now
		}
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
			NotificationService.error($rootScope.labels.FILE_PACK_BUY_PACK_ERROR_MESSAGE);
		});
	}

	$scope.loading = false;

}]);