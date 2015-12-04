SoonzikApp.controller('PacksCtrl', ['$scope', '$routeParams', 'SecureAuth', 'HTTPService', 'NotificationService', '$rootScope','$timeout', '$location',  function ($scope, $routeParams, SecureAuth, HTTPService, NotificationService, $rootScope, $timeout, $location) {

	$scope.loading = true;
	$scope.saveCart = [];

	$scope.newValuePercentage = {
		"artist": 65,
		"asso": 20,
		"web": 15
	};

	$scope.oldValuePercentage = {
		"artist": 65,
		"asso": 20,
		"web": 15
	};

	$scope.realValue = {
		"artist": 13,
		"asso": 4,
		"web": 3
	}

	$scope.percentages = [
		{ value: $scope.newValuePercentage["artist"], label: "Artist" },
		{ value: $scope.newValuePercentage["asso"], label: "Association" },
		{ value: $scope.newValuePercentage["web"], label: "website" }
	];

	$scope.input = { price: 20 }

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
				NotificationService.error($rootScope.labels.FILE_PACK_LOAD_ERROR_MESSAGE);
			});

		});

		$scope.Pack = true;

	}

	$scope.showPacksById = function() {
		var id = $routeParams.id;
		$scope.amountDonation = 20;

		SecureAuth.securedTransaction(function(key, user_id) {
			var parameters = [
				{ key: "secureKey", value: key },
				{ key: "user_id", value: user_id }
			];

			HTTPService.showPack(id, parameters).then(function(response) {
				$scope.thisPack = response.data.content;
				console.log($scope.thisPack);
				$scope.end_date = $scope.thisPack.end_date;
				timeLeft();
				$scope.loading = false;
			}, function (error) {
				NotificationService.error($rootScope.labels.FILE_PACK_LOAD_ONE_PACK_ERROR_MESSAGE);
			});
		});

		$scope.thisPackId = true;

	}

	$scope.varRange = function(key) {
		var barToChange = [];
		var diff = $scope.newValuePercentage[key] - $scope.oldValuePercentage[key];
		var coef = (diff < 0) ? -1 : 1;

		for (var index in $scope.newValuePercentage) {
			if (index != key) {
				barToChange.push(index);
			}
		}

		updateMySlider(barToChange, diff, coef);

	}

	var updateMySlider = function(sliders, diff, coef) {
		while (diff != 0) {
			for (var i = 0; i < 2 && diff != 0 ; i++) {
				if ((diff > 0 && $scope.newValuePercentage[sliders[i]] > 0) || (diff < 0 && $scope.newValuePercentage[sliders[i]] < 100)) {
					diff -= coef;
					$scope.newValuePercentage[sliders[i]] -= coef;
       	}
     	}
   	}
		for (var index in $scope.newValuePercentage) {
			$scope.oldValuePercentage[index] = $rootScope.toInt($scope.newValuePercentage[index]);
			$scope.realValue[index] = (($scope.input.price * $scope.newValuePercentage[index]) / 100);
		}

		$scope.percentages = [
			{ value: $rootScope.toInt($scope.newValuePercentage["artist"]), label: "Artist" },
			{ value: $rootScope.toInt($scope.newValuePercentage["asso"]), label: "Association" },
			{ value: $rootScope.toInt($scope.newValuePercentage["web"]), label: "website" }
		];
	}

	$scope.updatePrice = function() {
		if ($rootScope.toInt($scope.input.price) < $scope.thisPack.minimal_price) {
			$scope.input.price = $scope.thisPack.minimal_price;
		}

		for (var index in $scope.newValuePercentage) {
			$scope.realValue[index] = (($scope.input.price * $scope.newValuePercentage[index]) / 100);
		}
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
