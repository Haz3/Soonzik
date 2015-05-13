SoonzikApp.directive('autoScrollBottom', [function() {

	return function ($scope, elem, attr) {
		if ($scope.$last){
    	elem.parent().scrollTop(elem.parent().prop("scrollHeight"));
  	}
	}
}]);