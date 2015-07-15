SoonzikApp.controller('ListeningsCtrl', ['$scope', "$routeParams", 'SecureAuth', 'HTTPService', 'NotificationService', 'uiGmapGoogleMapApi', '$timeout', function ($scope, $routeParams, SecureAuth, HTTPService, NotificationService, uiGmapGoogleMapApi, $timeout) {

	var id = 0;
	$scope.loading = true;
	$scope.place = null;
	$scope.location = -1;
	$scope.circle = {
    center: {
      latitude: 0,
      longitude: 0
    },
    radius: 50000,
    stroke: {
      color: '#333',
      weight: 2,
      opacity: 0.5
    },
    fill: {
      color: '#EEE',
      opacity: 0.3
    },
    geodesic: true, // optional: defaults to false
    clickable: true, // optional: defaults to true
    editable: true, // optional: defaults to false
    visible: true, // optional: defaults to true
    events: {
    	click: function(a, b, c, d) {
    		$scope.$apply(function () {
	    		var markers = JSON.parse(JSON.stringify($scope.map.markers));
	    		markers.push(generateCursor(d[0].latLng.k, d[0].latLng.D, "my location"));
	    		$scope.map.markers = markers;
    		});
    	}
    }
  }

	$scope.init = function() {
		if (navigator.geolocation) {
			$scope.loading = false;
			$scope.location = 1;
			navigator.geolocation.getCurrentPosition(function(position) {
				console.log(position);
				uiGmapGoogleMapApi.then(function(maps) {
					$scope.map = {
						center: {
							latitude: position.coords.latitude,
							longitude: position.coords.longitude
						},
						zoom: 9,
						events: {
				    	click: function(a, b, c) {
				    		$scope.$apply(function () {
					    		var markers = JSON.parse(JSON.stringify($scope.map.markers))
					    		markers.push(generateCursor(c[0].latLng.k, c[0].latLng.D, "my location"));
					    		$scope.map.markers = markers;
						    });
				    	}
				    },
				    markers: []
					};
					$scope.circle.center = { latitude: position.coords.latitude, longitude: position.coords.longitude };
					$scope.location = 2;
				});
			});
		} else {
			$scope.location = 0;
		}
	}

	var generateCursor = function(lat, lng, txt) {
		id++;
		return {
      latitude: lat,
      longitude: lng,
      title: txt,
      idKey: id,
      show: false,
      events: {
	      click: function(a, b, c) {
	      	$scope.$apply(function () {
		      	c.show = !c.show;
		      });
	      }
    	}
    };
	}
}]);