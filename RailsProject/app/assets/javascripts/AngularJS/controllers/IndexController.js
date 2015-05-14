SoonzikApp.controller('IndexCtrl', ['$scope', 'SecureAuth', 'HTTPService', function ($scope, SecureAuth, HTTPService) {
	
	$scope.loading = true;


	var parameters = [{
				key: "order_by_desc[]", value: "created_at"
			}, {
				key: "limit", value: 4
	}];

	console.log(HTTPService.findPacks(parameters));
	HTTPService.findPacks(parameters).then(function (pack) {

		console.log(pack.data.content);
		var dataPack = pack.data.content;

		for (var index in pack.data.content) {
			$scope.title = pack.data.content[index].title;
		}

	}, function (error) {
   		// Gérer l’erreur proprement
	})

	$scope.loading = false;
}]);