SoonzikApp.directive('onScroll', [function() {
	return {
		restrict: 'A',
		scope: {
    	'onScroll': '&',
    	'scrollPosition': '='
    },
		link: function ($scope, elem, attr) {
			if ($scope.scrollPosition != "top" && $scope.scrollPosition != "bottom") {
				$scope.scrollPosition = "bottom";
			}
			elem.on("scroll", function(event) {
				if (($scope.scrollPosition == "bottom" && elem.scrollTop() == scrollHeight) ||
						($scope.scrollPosition == "top" && elem.scrollTop() == 0)) {
					$scope.onScroll();
				}
			});
		}
	};
}]);