SoonzikApp.controller('NewsCtrl', ['$scope', '$routeParams', 'SecureAuth', 'HTTPService', function ($scope, $routeParams, SecureAuth, HTTPService) {

	$scope.loading = true;

	$scope.initFoundation = function () {
		$(document).foundation();
	}

	$scope.showNews = function() {
		var parameters = [
			{ key: "order_by_asc[]", value: "date" }
		];

		$scope.News = true;

		HTTPService.findNews(parameters).then(function(news) {
			
			$scope.news = news.data.content;
			console.log($scope.news);


		}, function (error) {
			console.log("No News Available");
		})
	}

	$scope.showNewsById = function() {
		var id = $routeParams.id;

		HTTPService.showNews(id).then(function(response) {

			$scope.thisNews = response.data.content;
			$scope.attachments = $scope.thisNews.attachments;
			$scope.author = $scope.thisNews.user;

			console.log($scope.author);


		}, function (error) {
			console.log("This news doesn't exist");
		});

		$scope.thisNewsId = true;
	
	}

	$scope.comment = function() {

 		var current_user = SecureAuth.getCurrentUser();
		var parameters = [
			{key: "id", value: "1"},
			{key: "content", value: "commentaire n°1"}		
		];

	}

	$scope.showComment = function() {
		
	}

	$scope.loading = false;

}]);