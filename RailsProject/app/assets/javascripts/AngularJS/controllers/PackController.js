SoonzikApp.controller('PacksCtrl', ['$scope', '$routeParams', 'SecureAuth', 'HTTPService', 'NotificationService', '$rootScope','$timeout', '$location',  function ($scope, $routeParams, SecureAuth, HTTPService, NotificationService, $rootScope, $timeout, $location) {

	$scope.loading = true;
	$scope.saveCart = [];

	$scope.initFoundation = function () {
		$(document).foundation();
	}

	$scope.showPacks = function() {
		SecureAuth.securedTransaction(function(key, id) {
			var parameters = [
				{ key: "limit", value: 4 },
				{ key: "order_by_desc[]", value: "created_at" },
				{ key: "secureKey", value: key },
				{ key: "user_id", value: id }
			];
			
			HTTPService.findPacks(parameters).then(function(packs) {
				
				$scope.pack = packs.data.content;
				$scope.loading = false;

			}, function (error) {
				console.log($rootScope.labels.FILE_PACK_LOAD_ERROR_MESSAGE);
			});
		});

		$scope.Pack = true;
	
	}

	$scope.showPacksById = function() {
		var id = $routeParams.id;

		$scope.percentages = [
			{ value: 65, label: "Artist" },
			{ value: 20, label: "Association" },
			{ value: 15, label: "website" }
		];
		$scope.amountDonation = 20;
		

		SecureAuth.securedTransaction(function(key, id) {
			var parameters = [
				{ key: "secureKey", value: key },
				{ key: "user_id", value: id }
			];

			HTTPService.showPack(id, parameters).then(function(response) {
				$scope.thisPack = response.data.content;
				$scope.end_date = $scope.thisPack.end_date;
				timeLeft();
				$scope.loading = false;
			}, function (error) {
				console.log($rootScope.labels.FILE_PACK_LOAD_ONE_PACK_ERROR_MESSAGE);
			});
		});

		$scope.thisPackId = true;
	
	}

	$scope.managePrice = function () {

		$scope.priceMini = 20;

		$scope.artistPercentage = (($scope.priceMini * 65) / 100);
		$scope.associationPercentage = (($scope.priceMini * 20) / 100);
		$scope.websitePercentage = (($scope.priceMini * 15) / 100);
	}

	var timeLeft = function() {
		
		var timer = setInterval(function() {
			var now = new Date();
			var end = new Date($scope.end_date);
		
			if (end > now) {
				var countDown = end - now;
			} else {
				var left = "Finish !";
			}

       		var date = new Date(countDown);
       		var hours = date.getHours();
       		var minutes = "0" + date.getMinutes();
       		var seconds = "0" + date.getSeconds();
			var formattedTime = hours + 'h ' + minutes.substr(-2) + 'mn ' + seconds.substr(-2) + 's';

			$scope.thisPack.timeLeftPack = formattedTime;
			$scope.$apply();

    	}, 1000);
	}

	$scope.toPayment = function() {
		document.location.href = "/purchase/pack/" + $routeParams.id + "?amount=" + $scope.amountDonation + "&artist=" + $scope.percentages[0].value + "&association=" + $scope.percentages[1].value + "&website=" + $scope.percentages[2].value;
	}

}]);