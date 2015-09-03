SoonzikApp.directive('onScroll', [function() {
	return {
		restrict: 'A',
		scope: {
    	'onScroll': '&',
    	'scrollPosition': '='
    },
		link: function ($scope, $element, attr) {
			if ($scope.scrollPosition != "top" && $scope.scrollPosition != "bottom") {
				$scope.scrollPosition = "bottom";
			}
			$element.on("scroll", function(event) {
				console.log($scope.scrollPosition, $element.scrollTop() + $element.height(), $element.context.scrollHeight);
				if (($scope.scrollPosition == "bottom" && $element.scrollTop() + $element.height() == $element.context.scrollHeight) ||
						($scope.scrollPosition == "top" && $element.scrollTop() == 0)) {
					console.log("la fonction");
					$scope.onScroll();
				}
			});
		}
	};
}]);