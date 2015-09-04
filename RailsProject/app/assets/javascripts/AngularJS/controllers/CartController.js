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

	$scope.initCart = function() {

	}

	$scope.showCart = function() {


	  	SecureAuth.securedTransaction(function (key, id) {

			var parameters = [
				{ key: "user_id", value: id },
				{ key: "secureKey", value: key }
			];

			HTTPService.showCart(parameters).then(function(response) {

				$scope.carts = response.data.content;

				console.log($scope.carts);


			}, function(repsonseError) {
				NotificationService.error("Error get Cart");
			});
		}, function(error) {
			NotificationService.error("Error securedTransaction");
		});
  
  	$scope.loading = false;
  
  }



}]);
