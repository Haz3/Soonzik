SoonzikApp.controller('CartCtrl', ['$scope', 'SecureAuth', 'HTTPService', '$timeout', function ($scope, SecureAuth, HTTPService, $timeout) {

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
		var parameters = {
 			secureKey: key,
			user_id: user_id
		};

	  	SecureAuth.securedTransaction(function (key, user_id) {		

			HTTPService.showCart(parameters).then(function(response) {
				$scope.cart = response.data.content;
				$scope.haveMusic = true;
				$scope.haveAlbum = true;
			
			}, function(repsonseError) {
				NotificationService.error("Error Add To Cart");
			});
		}, function(error) {
			NotificationService.error("Error securedTransaction");
		});
  	$scope.loading = false;
  }


}]);
