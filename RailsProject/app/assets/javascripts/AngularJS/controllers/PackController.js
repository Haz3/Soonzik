SoonzikApp.controller('PacksCtrl', ['$scope', '$routeParams', 'SecureAuth', 'HTTPService', 'NotificationService', '$rootScope','$timeout', '$location',  function ($scope, $routeParams, SecureAuth, HTTPService, NotificationService, $rootScope, $timeout, $location) {

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
			$scope.loading = false;

		}, function (error) {
			console.log($rootScope.labels.FILE_PACK_LOAD_ERROR_MESSAGE);
		});

		$scope.Pack = true;

	}

	$scope.showPacksById = function() {
		var id = $routeParams.id;
		$scope.amountDonation = 20;

		HTTPService.showPack(id).then(function(response) {

			$scope.thisPack = response.data.content;
			$scope.end_date = $scope.thisPack.end_date;
			timeLeft();
			$scope.loading = false;


		}, function (error) {
			console.log($rootScope.labels.FILE_PACK_LOAD_ONE_PACK_ERROR_MESSAGE);
		});

		$scope.thisPackId = true;

	}

	$scope.managePrice = function () {

		$scope.priceMini = 20;

		// Set default value
		angular.element('#range-slider-artist').foundation('slider', 'set_value', (($scope.priceMini * 65) / 100));
		angular.element('#range-slider-asso').foundation('slider', 'set_value', (($scope.priceMini * 20) / 100));
		angular.element('#range-slider-web').foundation('slider', 'set_value', (($scope.priceMini * 15) / 100));

		// On change Function
		angular.element(document).foundation({
			slider: {
				on_change: function() {
					// get value of slider
					var range_artist = angular.element('#range-slider-artist').attr('data-slider');
					var range_asso = angular.element('#range-slider-asso').attr('data-slider');
					var range_web = angular.element('#range-slider-web').attr('data-slider');

					// add value to scope
					$scope.rangeArtist = range_artist;
					$scope.rangeAsso = range_asso;
					$scope.rangeWeb = range_web;

					// get percentage of value
					$scope.artistPercentage = (($scope.rangeArtist / $scope.priceMini) * 100);
					$scope.associationPercentage = (($scope.rangeAsso / $scope.priceMini) * 100);
					$scope.websitePercentage = (($scope.rangeWeb / $scope.priceMini) * 100);

					// add percentage to donut graph
					$scope.percentages = [
						{ value: $scope.artistPercentage, label: "Artist" },
						{ value: $scope.associationPercentage, label: "Association" },
						{ value: $scope.websitePercentage, label: "website" }
					];

					if ($scope.rangeArtist == $scope.priceMini) {

						angular.element('#range-slider-asso').foundation('slider', 'set_value', 0);
						angular.element('#range-slider-web').foundation('slider', 'set_value', 0);
					} else if ($scope.rangeAsso == $scope.priceMini) {

						angular.element('#range-slider-web').foundation('slider', 'set_value', 0);
						angular.element('#range-slider-artist').foundation('slider', 'set_value', 0);
					} else if ($scope.rangeWeb == $scope.priceMini) {

						angular.element('#range-slider-artist').foundation('slider', 'set_value', 0);
						angular.element('#range-slider-asso').foundation('slider', 'set_value', 0);
					}

				}
			}
		});

	//	angular.element(document).foundation('slider', 'reflow');
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
