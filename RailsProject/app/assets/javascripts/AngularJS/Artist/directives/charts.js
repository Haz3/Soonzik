SoonzikArtistApp.directive('charts', function() {
  return {
  	restrict: 'E',
  	scope: {
      'typeChart': '=',
      'values': '=',
      'xkey': '=',
      'ykeys': '=',
    	'labels': '='
    },
  	link: function ($scope, $element, attrs) {
      if ($scope.values.length == 0) {
        $element.html("No values are currently available");
        return;
      }

      var w1 = $element.parent().width();
      var w2 = $scope.values.length * 30 * 2; // two bars

      $element.width(((w1 > w2) ? w1 : w2) + "px");

      if ($scope.typeChart == "bar") {
        Morris.Bar({
          element: $element,
          data: $scope.values,
          xkey: $scope.xkey,
          ykeys: $scope.ykeys,
          labels: $scope.labels
        });
        $element.height("400px");
      } else if ($scope.typeChart == "line") {
        Morris.Line({
          element: $element,
          data: $scope.values,
          xkey: $scope.xkey,
          ykeys: $scope.ykeys,
          labels: $scope.labels
        });
        $element.height("400px");
      } else {
        Morris.Donut({
          element: $element,
          data: $scope.values
        });
      }
		}
  };
});

