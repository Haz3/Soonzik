SoonzikApp.controller('CartCtrl', ['$scope', 'SecureAuth', 'HTTPService', '$timeout', 'NotificationService', function ($scope, SecureAuth, HTTPService, $timeout, NotificationService) {

	$scope.loading = true;
	$scope.haveAlbum = false;
	$scope.haveMusic = false;

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
				console.log($scope.carts);
				if ($scope.carts) {
					$scope.showItem = true;
				} else {
					$scope.showItem = false;
				}

			}, function(repsonseError) {

				NotificationService.error("Error get Cart");
			});

		}, function(error) {
			NotificationService.error("Error securedTransaction");
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

				NotificationService.success("Objet détruit");

			}, function(error) {
				NotificationService.error("Erreur lors de la destruction");
			});

		}, function(error) {
			NotificationService.error("Error securedTransaction");
		});
	}

	$scope.buyCart = function() {
		SecureAuth.securedTransaction(function(key, id) {
			
			var parameters = [
				{ key: "secureKey" ,value: key },
				{ key: "user_id", value: id }
			];

			HTTPService.buyCart(parameters).then(function(response) {

				NotificationService.success("Le panier a bien été acheté");

			}, function(error) {
				NotificationService.success("Une erreur est survenu lors de l'achat du panier");
			});
		}, function(error) {
			NotificationService.success("Erreur securedTransaction");
		});
	}

}]);
