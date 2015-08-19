SoonzikApp.controller('NewsCtrl', ['$scope', '$routeParams', 'SecureAuth', 'HTTPService', function ($scope, $routeParams, SecureAuth, HTTPService) {

	$scope.loading = true;

	$scope.commentariesOffset = 0;
	$scope.commentaries = [];
	$scope.commentLoading = false;
	$scope.commentary = { content: "" }


	$scope.initFoundation = function () {
		$(document).foundation();
	}

	$scope.showNews = function() {
		var parameters = [
			{ key: "order_by_asc[]", value: "date"}
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

		$(window).scroll(function() {
			if($(window).scrollTop() + $(window).height() == $(document).height() && $scope.commentLoading == false) {
				$scope.$apply(function() {
					$scope.commentLoading = true;
					$scope.showComments();
				});
			}
		});

		$scope.thisNewsId = true;

	}

	$scope.showComments = function() {

		var parameters = [
  			{ key: "offset", value: $scope.commentariesOffset },
  			{ key: "limit", value: 20 },
//  			{ order_reverse: false }
  		];

  		var newsId = $routeParams.id;
		
		HTTPService.showComment(newsId, parameters).then(function(response) {

			$scope.commentaries = $scope.commentaries.concat(response.data.content);
			$scope.commentariesOffset = $scope.commentaries.length;
			$scope.commentLoading = false;
  		
  		}, function(error) {
  			NotificationService.error("Error while loading commentaries");
  		});
	}

	$scope.postComment = function() {
		SecureAuth.securedTransaction(function(key, id) {
			var parameters =
		  		{	secureKey: key,
			  		user_id: id,
			  		content: $scope.commentary.content
			  	};

			HTTPService.addComment($routeParams.id, parameters).then(function(response) {
				
				$scope.commentaries.push(response.data.content);
				$scope.commentariesOffset++;
				$scope.commentary.content = "";

			}, function(error) {
				NotificationService.error("Error while saving your comment, please try later");
			});
		}, function(error) {
			NotificationService.error("Error while saving your comment, please try later");
		});
	}

	$scope.loading = false;

}]);