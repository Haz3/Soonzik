SoonzikApp.controller('ConcertsCtrl', ['$scope', 'SecureAuth', 'HTTPService', '$timeout', '$rootScope', '$routeParams', function ($scope, SecureAuth, HTTPService, $timeout, $rootScope, $routeParams) {

	$scope.loading = true;
	$scope.indexView = { concerts: [], numberPages: 0, currentPage: 1 };
	$scope.showView = { concert: null };

	var ConcertPerPage = 10;

	$scope.initIndex = function() {
		$scope.indexView.currentPage = (toInt($routeParams.page) == 0 ? 1 : toInt($routeParams.page));

		var parameters = [
			{ key: "limit", value: ConcertPerPage },
			{ key: "offset", value: (($scope.indexView.currentPage - 1) * ConcertPerPage) },
			{ key: "order_by_desc[]", value: "created_at" }
		];

		HTTPService.getConcerts([{ key: "count", value: "true" }]).then(function(response) {
			var numberResults = response.data.content;

			if (typeof numberResults != "undefined") {
				$scope.indexView.numberPages = ~~(numberResults / ConcertPerPage) + 1;
			} else {
				$scope.indexView.numberPages = 1;
			}

			HTTPService.findConcerts(parameters).then(function(response) {
				$scope.indexView.concerts = response.data.content;
				$scope.loading = false;
			}, function(error) {
				NotificationService.error(" rootScope.labels. ");
			});

		}, function(error) {
			NotificationService.error(" rootScope.labels. ");
		});
	}

	/* Utils function */

	$scope.range = function(n) {
  	return new Array(n);
  }

  $scope.min = function(a, b) {
  	return (a < b ? a : b);
  }

  $scope.max = function(a, b) {
  	return (a > b ? a : b);
  }

	var toInt = function(value) {
		var number = parseInt(value);
		if (isNaN(number)) {
			return 0;
		} else {
			return number;
		}
	}

	$scope.formatAddress = function(address) {
		return address.numberStreet + " " + address.street + ", " + address.zipcode + " " + address.city + ", " + address.country;
	}
}]);