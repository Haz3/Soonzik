SoonzikApp.directive('battle', [function() {

	var drawMyDonut = function(elem, values) {
		if (values.length == 0) {
			elem.html("Currently no votes");
			return;
    }

		var w = elem.parent().width();

		elem.width(w - 10 + "px");

		var total = 0;
		for (var index in values) {
			total += values[index].value;
		}

		Morris.Donut({
		  element: elem,
		  data: values,
		  formatter: function (x) { return (Math.round((x / total * 100) * 100) / 100) + "%"}
		});
	}

	return {
		restrict: 'E',
		scope: {
			'battleValues': '='
		},
		link: function ($scope, elem, attr) {
			var values = [
			    {value: 700, label: 'foo'},
			    {value: 500, label: 'A really really long label'}
			  ];

			$(window).resize(function() {
				elem.html("");
      	drawMyDonut(elem, $scope.battleValues);
    	});

    	$scope.$watch('battleValues', function(newValue, oldValue) {
				elem.html("");
    		drawMyDonut(elem, newValue);
      }, true);

     	drawMyDonut(elem, $scope.battleValues);
		}
	};
}]);