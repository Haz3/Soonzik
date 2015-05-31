SoonzikApp.directive('music', ["$rootScope", function($rootScope) {
	return {
		restrict: 'E',
		scope: {
			"musicObject": "=",
			"artist": "="
		},
		link: function ($scope, $element, attr) {
			$element.on("click", function() {
				$rootScope.$broadcast('player:play', { song: $scope.musicObject, artist: $scope.artist });
			});
		}
	};
}]);