SoonzikApp.directive('autoFocus', [function() {
	return {
		restrict: 'A',
		link: function ($scope, elem, attr) {
			elem.focus();
		}
	};
}]);