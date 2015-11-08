SoonzikApp.controller('ConcertsCtrl', ['$scope', 'SecureAuth', 'HTTPService', '$timeout', '$rootScope', '$routeParams', function ($scope, SecureAuth, HTTPService, $timeout, $rootScope, $routeParams) {

	$scope.loading = true;
	$scope.indexView = { concerts: [], numberPages: 0, currentPage: 1 };
	$scope.modelObj = {
		user: { username: "" },
		address: { country: "" }
	}

	var ConcertPerPage = 10;

	$scope.initIndex = function() {
		$scope.indexView.currentPage = (toInt($routeParams.page) == 0 ? 1 : toInt($routeParams.page));

		SecureAuth.securedTransaction(function(key, id) {
			var countParameters = [
				{ key: "secureKey", value: key },
				{ key: "user_id", value: id },
				{ key: "count", value: "true" }
			];
			var parameters = [
				{ key: "limit", value: ConcertPerPage },
				{ key: "offset", value: (($scope.indexView.currentPage - 1) * ConcertPerPage) },
				{ key: "order_by_desc[]", value: "created_at" },
				{ key: "secureKey", value: key },
				{ key: "user_id", value: id },
			];

			HTTPService.getConcerts(countParameters).then(function(response) {
				var numberResults = response.data.content;

				if (typeof numberResults != "undefined") {
					$scope.indexView.numberPages = ~~(numberResults / ConcertPerPage) + 1;
				} else {
					$scope.indexView.numberPages = 1;
				}

				HTTPService.findConcerts(parameters).then(function(response) {
					$scope.indexView.concerts = response.data.content;
					var now = new Date();
					for (var i = $scope.indexView.concerts.length - 1 ; i >= 0 ; i--) {
						var d = new Date($scope.indexView.concerts[i].planification);
						if (d < now) {
							$scope.indexView.concerts.splice(i, 1);
						}
					}
					$scope.loading = false;
				}, function(error) {
					NotificationService.error($rootScope.labels.FILE_CONCERT_FIND_CONCERT_ERROR_MESSAGE);
				});

			}, function(error) {
				NotificationService.error($rootScope.labels.FILE_CONCERT_FIND_CONCERT_ERROR_MESSAGE);
			});
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