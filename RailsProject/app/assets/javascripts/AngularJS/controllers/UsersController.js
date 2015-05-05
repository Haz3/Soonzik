SoonzikApp.controller('UsersCtrl', ['$scope', "$routeParams", 'SecureAuth', 'HTTPService', function ($scope, $routeParams, SecureAuth, HTTPService) {
	$scope.loading = true;

	$scope.show = {};


	$scope.showInit = function () {
		var id = $routeParams.id;

		HTTPService.getProfile(id).then(function(profile) {
			var data = profile.data.content;
			$scope.show.user = {
				username: data.username,
				image: "/assets/" + data.image,
				followers: [],					// Pas dans la réponse de l'API pour le moment
				facebook: linkToNothing(data.facebook),
				twitter: linkToNothing(data.twitter),
				googlePlus: linkToNothing(data.googlePlus),
				isArtist: true,					// Pas dans la réponse de l'API pour le moment
				topFive: [							// Pas dans la réponse de l'API pour le moment
					{
						title: "MaMusique1",
						duration: 120,
						prive: 2.99
					}
				],
				albums: []							// Pas dans la réponse de l'API pour le moment
			}
			$scope.loading = false;
		}, function(error) {
			console.log(error);
		});
	}

	function	linkToNothing(value) {
		if (value == null)
			return "#"
		else
			return value;
	}

}]);