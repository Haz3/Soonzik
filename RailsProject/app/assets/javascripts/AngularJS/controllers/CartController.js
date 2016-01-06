SoonzikApp.controller('CartCtrl', ['$scope', 'SecureAuth', 'HTTPService', '$timeout', 'NotificationService', '$rootScope', function ($scope, SecureAuth, HTTPService, $timeout, NotificationService, $rootScope) {

	$scope.loading = true;
	$scope.totalPrice = 0;

	/*
	**	Fonction d'init de foundation.
	*/

	$scope.initFoundation = function () {
		$(document).foundation();
	}


	$scope.showCart = function() {

		$scope.showItem = false;

		SecureAuth.securedTransaction(function (key, id) {

			var parameters = [
				{ key: "user_id", value: id },
				{ key: "secureKey", value: key }
			];

			HTTPService.showCart(parameters).then(function(response) {
				$scope.carts = response.data.content;

				if ($scope.carts.length != 0) {
					$scope.showItem = true;
				} else {
					$scope.showItem = false;
				}

				var priceAlbum = 0;
				for (var i = 0; i < $scope.carts.length; i++) {
					for (var j = 0; j < $scope.carts[i].albums.length; j++) {
						priceAlbum += $scope.carts[i].albums[j].price;
					}
				}

				var priceMusics = 0;
				for (var i = 0; i < $scope.carts.length; i++) {
					for (var j = 0; j < $scope.carts[i].musics.length; j++) {
						priceMusics += $scope.carts[i].musics[j].price;
					}
				}

				$scope.totalPrice = priceAlbum + priceMusics;

			}, function(repsonseError) {
				NotificationService.error($rootScope.labels.FILE_CART_LOAD_ERROR_MESSAGE);
			});

		});
		$scope.loading = false;
	}

	$scope.deleteItem = function (cart_id) {
		SecureAuth.securedTransaction(function(key, id) {

			var parameters = [
				{ key: "secureKey" ,value: key },
				{ key: "user_id", value: id },
				{ key: "id", value: cart_id }
			];

			HTTPService.destroyItem(parameters).then(function(response) {

				NotificationService.success($rootScope.labels.FILE_CART_DELETE_SUCCESS_MESSAGE);
				$scope.showCart();
			}, function(error) {
				NotificationService.error($rootScope.labels.FILE_CART_DELETE_ITEM_ERROR_MESSAGE);
			});

		});
	}

	$scope.toPayment = function() {
		document.location.href = "/purchase/cart/";
	}

}]);
