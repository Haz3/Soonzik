SoonzikApp.controller('NewsCtrl', ['$scope', '$routeParams', 'SecureAuth', 'HTTPService', 'NotificationService', "$rootScope", function ($scope, $routeParams, SecureAuth, HTTPService, NotificationService, $rootScope) {

	$scope.loading = true;

	$scope.news = [];
	$scope.index = {
		currentPage: 1
	};

	$scope.resourcesCommentaries = [];
	$scope.commentLoading = false;
	$scope.commentary = { 
		content : ""
	};

	$scope.initIndexNews = function() {
		$scope.index.currentPage = (toInt($routeParams.page) == 0 ? 1 : toInt($routeParams.page));
		$scope.loadNews();
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

	$scope.loadNews = function() {
		$scope.loading = true;
		var parameters = [
			{ key: "order_by_desc[]", value: "created_at"},
  			{ key: "offset", value: ($scope.index.currentPage - 1) * 20 },
  			{ key: "limit", value: 20 }
		];

		HTTPService.findNews(parameters).then(function(response) {
			$scope.news = response.data.content;

			for (var indexNews in $scope.news) {
				if ($scope.news[indexNews].content.length > 170) {
					$scope.news[indexNews].content = $scope.news[indexNews].content.substr(0, 170) + "...";
				}
			}

			$scope.loading = false;
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
			{ key: "offset", value: $scope.resourcesCommentaries.length },
			{ key: "limit", value: 20 },
			{ key: "order_reverse", value: true }
  	];

  	var newsId = $routeParams.id;
		
		HTTPService.showComment(newsId, parameters).then(function(response) {

			$scope.resourcesCommentaries = $scope.resourcesCommentaries.concat(response.data.content);

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

				$scope.resourcesCommentaries.unshift(response.data.content);
				$scope.commentary.content = "";

			}, function(error) {
				NotificationService.error($rootScope.labels.FILE_NEWS_SEND_COMMENT_ERROR_MESSAGE);
			});
		}, function(error) {
			NotificationService.error($rootScope.labels.FILE_NEWS_SEND_COMMENT_ERROR_MESSAGE);
		});
	}

	/* Utils function */

	$scope.range = function(n) {
  	return new Array(n);
  }

  $scope.min = function(a, b) {
  	return (a < b ? a : b);
  }

  $scope.max = function(a, b) {
  	return (a > b ? a : b);
  }

	var toInt = function(value) {
		var number = parseInt(value);
		if (isNaN(number)) {
			return 0;
		} else {
			return number;
		}
	}

}]);