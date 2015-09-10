SoonzikApp.controller('NewsCtrl', ['$scope', '$routeParams', 'SecureAuth', 'HTTPService', 'NotificationService', "$rootScope", function ($scope, $routeParams, SecureAuth, HTTPService, NotificationService, $rootScope) {

	$scope.loading = true;

	$scope.news = [];
	$scope.newsLoading = false;
	$scope.newsOffset = 0;

	$scope.commentariesOffset = 0;
	$scope.commentaries = [];
	$scope.commentLoading = false;
	$scope.commentary = { 
		content : ""
	};

	$scope.initFoundation = function () {
		$(document).foundation();

	}

	$scope.initOneNews = function() {
		$scope.initFoundation();

		// Share Twitter
		!function(d,s,id)
            {
              var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';
              if(!d.getElementById(id)){
                js=d.createElement(s);
                js.id=id;
                js.src=p+'://platform.twitter.com/widgets.js';
                fjs.parentNode.insertBefore(js,fjs);
              }
            }(document, 'script', 'twitter-wjs');

        // Share Google Plus 
      	(function() {
      		var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
	        po.src = 'https://apis.google.com/js/client:plusone.js';
	        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
	    })();

	}

	$scope.initNews = function() {
		$scope.initFoundation();
		
		$(window).scroll(function() {
			if($(window).scrollTop() + $(window).height() == $(document).height() && $scope.newsLoading == false) {
				$scope.$apply(function() {
					$scope.newsLoading = true;
					$scope.showNews();
				});
			}
		});
	}

	$scope.showNews = function() {
		var parameters = [
			{ key: "order_by_desc[]", value: "created_at"},
  			{ key: "offset", value: $scope.newsOffset },
  			{ key: "limit", value: 20 }
		];

		$scope.News = true;

		HTTPService.findNews(parameters).then(function(response) {
			
			$scope.news = $scope.news.concat(response.data.content);
			$scope.newsOffset = $scope.news.length;
			$scope.newsLoading = false;

		}, function (error) {
			NotificationService.error($rootScope.labels.FILE_NEWS_LOAD_ERROR_MESSAGE);
		})
	}

	$scope.showNewsById = function() {

		var newsId = $routeParams.id;

		HTTPService.showNews(newsId).then(function(response) {

			$scope.thisNews = response.data.content;
			$scope.attachments = $scope.thisNews.attachments;
			$scope.author = $scope.thisNews.user;
			$scope.showComments();

		$(window).scroll(function() {
			if($(window).scrollTop() + $(window).height() == $(document).height() && $scope.newsLoading == false) {
				$scope.$apply(function() {
					$scope.newsLoading = true;
					$scope.showComments();
				});
			}
		});

		}, function (error) {
			NotificationService.error($rootScope.labels.FILE_NEWS_ONE_NEWS_ERROR_MESSAGE);
		});

		$scope.thisNewsId = true;

	}

	$scope.showComments = function() {

		var parameters = [
			{ key: "offset", value: $scope.commentaries.length },
			{ key: "limit", value: 20 },
			{ key: "order_reverse", value: true }
  	];

  	var newsId = $routeParams.id;
		
		HTTPService.showComment(newsId, parameters).then(function(response) {

			$scope.commentaries = $scope.commentaries.concat(response.data.content);

			$scope.commentLoading = false;
  		
  		}, function(error) {
  			NotificationService.error($rootScope.labels.FILE_NEWS_LOAD_COMMENT_ERROR_MESSAGE);
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

				$scope.commentaries.unshift(response.data.content);
				$scope.commentary.content = "";

			}, function(error) {
				NotificationService.error($rootScope.labels.FILE_NEWS_SEND_COMMENT_ERROR_MESSAGE);
			});
		}, function(error) {
			NotificationService.error($rootScope.labels.FILE_NEWS_SEND_COMMENT_ERROR_MESSAGE);
		});
	}

	$scope.loading = false;

}]);