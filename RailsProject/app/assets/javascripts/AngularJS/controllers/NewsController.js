SoonzikApp.controller('NewsCtrl', ['$scope', '$routeParams', 'SecureAuth', 'HTTPService', function ($scope, $routeParams, SecureAuth, HTTPService) {

	$scope.loading = true;
	$scope.commentary = { content: "" }

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

		}, function (error) {
			console.log("No News Available");
		})
	}

	$scope.showNewsById = function() {
		var parameters = [
			{ order_reverse: false }
		];

		var newsId = $routeParams.id;

		HTTPService.showNews(newsId).then(function(response) {

			$scope.thisNews = response.data.content;
			$scope.attachments = $scope.thisNews.attachments;
			$scope.author = $scope.thisNews.user;

		}, function (error) {
			console.log("This news doesn't exist");
		});

		HTTPService.showComment(newsId, parameters).then(function(response) {
			$scope.comments = response.data.content;
			console.log(parameters);

			console.log($scope.comments);
		}, function (error) {
			console.log("This news doesn't exist");
		});


		SecureAuth.securedTransaction(function(key, id) {
			var parameters =
		  		{	secureKey: key,
			  		user_id: id,
			  		content: "NULL" };
			
			HTTPService.addComment($routeParams.id, parameters).then(function(data) {
				parameters.content = $scope.commentary;

			}, function(error) {
				console.log("erreur HTTPService");
			});
		}, function(error) {
			console.log("erreur securedTransaction");
		});

		$scope.thisNewsId = true;

	}

	$scope.loading = false;

}]);