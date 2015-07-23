SoonzikApp.controller('CartCtrl', ['$scope', 'SecureAuth', 'HTTPService', '$timeout', function ($scope, SecureAuth, HTTPService, $timeout) {

	$scope.loading = true;

	/*
	**	Fonction d'init de foundation.
	*/

	$scope.initFoundation = function () {
		$(document).foundation();
		$(window).trigger("resize");
	}

}]);
