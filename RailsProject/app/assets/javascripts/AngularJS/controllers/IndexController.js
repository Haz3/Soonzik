SoonzikApp.controller('IndexCtrl', ['$scope', 'SecureAuth', 'HTTPService', '$timeout', 'NotificationService', function ($scope, SecureAuth, HTTPService, $timeout, NotificationService) {
	
	$scope.loading = true;
	$scope.loadingRightSide = true;
	$scope.loading_tweet = false;
	$scope.currentUser = false;
	$scope.randomVote = [];
	$scope.votes = [
		{ value: 0, label: "" },
		{ value: 0, label: "" }
	];
	$scope.user = false;
	$scope.voteCurrentUser = false;
	$scope.tweets = [];
	$scope.tweet = {
		input: ""
	}
	$scope.otherTweets = [];
	$scope.classLeftSide = {
		'medium-8': true
	}
	$scope.tab = 0;

	/*
	**	Fonction d'init de foundation.
	**	+ Init Slider.
	*/

	$scope.initIndex = function () {
		$(document).foundation({
		  orbit: {
		    animation: 'slide',
		    timer_speed: 1000,
		    pause_on_hover: true,
		    animation_speed: 500,
		    navigation_arrows: true,
		    bullets: false
		  }
		});
		$(window).trigger("resize");


		var current_user = SecureAuth.getCurrentUser();
		if (current_user.id != null && current_user.token != null && current_user.username != null) {
			$scope.user = current_user;
		}
		$scope.classLeftSide['medium-8'] = ($scope.user != false);

		/*
		**	Recupere les 3 dernieres news pour le slider.
		*/
		HTTPService.findNews([{ key: "order_by_desc[]", value: "date", limit: 4}]).then(function(news) {
			$scope.news = news.data.content;

			/*
			**	 Recupere les 4 derniers packs mis en ligne.
			*/

			var parameters = [
				{ key: "limit", value: 2 },
				{ key: "order_by_asc[]", value: "created_at" }
			];

			HTTPService.findPacks(parameters).then(function (packs) {
				$scope.packs = packs.data.content;
				timeLeftPack();


				/*
				**	ShowBattleInfo --> Récupère la derniere battle mis en ligne.
				*/

				var parameters = [
					{key: "order_by_desc[]", value: "created_at"},
					{key: "limit", value: 1}
				]

				$scope.showBattle = true;

				HTTPService.findBattles(parameters).then(function(response) {
					
					if (response.data.content.length > 0) {
						$scope.battle = response.data.content[0];

						if ($scope.battle.votes.length > 0) {
							$scope.votes = [
								{ value: 0, label: $scope.battle.artist_one.username },
								{ value: 0, label: $scope.battle.artist_two.username }
							];
							for (var voteIndex in $scope.battle.votes) {
								if ($scope.battle.votes[voteIndex].artist_id == $scope.battle.artist_one.id) {
									$scope.votes[0].value++;
								} else {
									$scope.votes[1].value++;
								}
								if ($scope.battle.votes[voteIndex].user_id == $scope.user.id) {
									$scope.voteCurrentUser = $scope.battle.votes[voteIndex].artist_id;
								}
							}
						} else {
							$scope.votes = false;
						}

						// Get top 5 of artists
						HTTPService.isArtist($scope.battle.artist_one.id).then(function(artistInformation) {
							/*- Begin isArtist - artist 1 -*/

							// Initialisation of the artist profile [if is one]
							var isArtist = artistInformation.data.content.artist;
							if (isArtist == true) {
								$scope.battle.artist_one.topFive = artistInformation.data.content.topFive;
								$scope.battle.artist_one.albums = artistInformation.data.content.albums;
							}

							HTTPService.isArtist($scope.battle.artist_two.id).then(function(artistInformation) {
								/*- Begin isArtist - artist 2 -*/

								// Initialisation of the artist profile [if is one]
								var isArtist = artistInformation.data.content.artist;
								if (isArtist == true) {
									$scope.battle.artist_two.topFive = artistInformation.data.content.topFive;
									$scope.battle.artist_two.albums = artistInformation.data.content.albums;
								}
								$scope.loading = false;
							}, function(error) {	// error management of the second isArtist
								NotificationService.error($rootScope.labels.FILE_BATTLE_LOAD_ARTIST_TWO_ERROR_MESSAGE)
							});
						}, function(error) {	// error management of the first isArtist
							NotificationService.error($rootScope.labels.FILE_BATTLE_LOAD_ARTIST_ONE_ERROR_MESSAGE);
						});

						randomPeople();

						$scope.loading = false;
					}
				}, function(error) {
					console.log("no battles available")
				});

			}, function (error) {
				console.log("There is no pack available");
			});
		}, function (error) {
			console.log("No News Available");
		});

		if ($scope.user != false) {
			SecureAuth.securedTransaction(function(key, id) {
				HTTPService.getFlux([{ key: "secureKey", value: key }, { key: "user_id", value: id }]).then(function(response) {
					$scope.tweets = response.data.content;

					var paramsTweet = [
						{ key: encodeURIComponent("attribute[msg]"), value: encodeURIComponent("%" + $scope.user.username + "%") }
					];
					HTTPService.findTweet(paramsTweet).then(function(response) {
						tmp_tweets = response.data.content;
						// Loop backward to splice inside
						for (var i = tmp_tweets.length - 1 ; i >= 0 ; i--) {
							if (tmp_tweets[i].user.id == id) {
								tmp_tweets.splice(i, 1);
							}
						}
						$scope.otherTweets = tmp_tweets;
						$scope.loadingRightSide = false;
					}, function(error) {
						NotificationService.error("");
					});
				}, function(error) {
					NotificationService.error("pb flux")
				});
			}, function(error) {
				NotificationService.error("pb flux")
			});
		}
	}

	$scope.voteFor = function(battle, artist) {
		if ($scope.user == false) {
			NotificationService.error($rootScope.labels.FILE_BATTLE_NEED_AUTHENTICATION_ERROR_MESSAGE);
			return;
		}
		if ($scope.voteCurrentUser == false || $scope.voteCurrentUser != artist.id) {
			SecureAuth.securedTransaction(function(key, id) {
				var parameters = {
					secureKey: key,
					user_id: id,
					artist_id: artist.id
				};
				HTTPService.voteBattle(battle.id, parameters).then(function(response) {
					// is there a previous vote ?
					var oldVote = true;
					// init the array of values
					if ($scope.votes.length == 0) {
						$scope.votes = [
							{ value: 0, label: $scope.battle.artist_one.username },
							{ value: 0, label: $scope.battle.artist_two.username }
						];
						oldVote = false;
					}
					$scope.voteCurrentUser = artist.id;

					// Iterate on the votes
					for (var voteIndex in $scope.battle.votes) {
						// We modify the vote value
						if ($scope.battle.votes[voteIndex].user_id == $scope.user.id) {
							$scope.battle.votes[voteIndex].artist_id = artist.id;
							
							// if you vote for the first
							if (artist.id == $scope.battle.artist_one.id) {
								$scope.votes[0].value++;
								// if there is a previous vote, reduce the value for the other artist
								if (oldVote) {	$scope.votes[1].value--;	}
							}
							else {		// if you vote for the second
								$scope.votes[1].value++;
								// if there is a previous vote, reduce the value for the other artist
								if (oldVote) {	$scope.votes[0].value--;	}
							}
						}
					}
				}, function(error) {
					NotificationService.error($rootScope.labels.FILE_BATTLE_VOTE_ERROR_MESSAGE);
				});
			}, function(error) {
				NotificationService.error($rootScope.labels.FILE_BATTLE_VOTE_ERROR_MESSAGE);
			});
		} else {
			NotificationService.info($rootScope.labels.FILE_BATTLE_ALREADY_VOTED_ERROR_MESSAGE);
		}
	}


	$scope.voteClass = function(value, artist_id) {
		if (value == false) {
			return 'primary';
		} else if (value == artist_id) {
			return 'success';
		} else {
			return 'alert';
		}
	}

	$scope.voteText = function(value, artist_id) {
		if (value == false) {
			return 'Vote';
		} else if (value == artist_id) {
			return 'You voted for this artist';
		} else {
			return 'Cancel your old vote and vote for this artist !';
		}
	}


	var randomPeople = function() {
		var votes = $scope.battle.votes;
		var count = 0;
		var id_array = [];

		if (votes.length <= 6) {
			for (var indexVote in votes) {
				id_array.push(votes[indexVote].user_id);
			}
		} else {
			while (count < 6) {
				var randomNumber = ~~(Math.random() * votes.length);
				console.log(randomNumber);
				if ($.inArray(randomNumber, id_array)) {
					continue;
				} else {
					id_array.push(randomNumber);
					count++;
				}
			}
		}
		fillArray_rec($scope.randomVote, 0, id_array, (votes.length <= 6) ? votes.length : 6);
	}

	var fillArray_rec = function(array, index, id_array, limit) {
		HTTPService.getProfile(id_array[index]).then(function(profile) {
			array[index] = profile.data.content;
			if (index + 1 < limit) {
				fillArray_rec(array, index + 1, id_array, limit);
			}
		}, function(error) {
			array[index] = null;
		});
	}

	var timeLeftPack = function() {
		var now = new Date();

		for (var i = 0 ; i < $scope.packs.length ; i++) {
			var end = new Date($scope.packs[i].end_date);
			var left = (end > now) ? end - now : "Finish !"

			if (left != "Finish !") {
				var date = new Date(left);
				var hours = date.getHours();
				var minutes = "0" + date.getMinutes();
				var seconds = "0" + date.getSeconds();
				left = hours + 'h' + minutes.substr(-2) + 'mn' + seconds.substr(-2) + 's';
			}
			$scope.packs[i].timeLeft = left;
		}
		$timeout(timeLeftPack, 1000);
	}

	$scope.comment = function(username) {
		$("#inputTweet").focus();
		$scope.tweet.input = "@" + username + " ";
	}

	$scope.sendTweet = function() {
		if ($scope.tweet.input.length < 140) {

			var parameters = {
				msg: $scope.tweet.input,
				user_id: $scope.user.id
			}

			SecureAuth.securedTransaction(function(key, user_id) {
				parameters.user_id = user_id;
				parameters.secureKey = key;
				HTTPService.saveTweet(parameters).then(function(response) {
					$scope.tweets.unshift(response.data.content);
					$scope.tweet.input = "";
				}, function(error) {
					NotificationService.error($rootScope.labels.FILE_USER_SAVE_TWEET_ERROR_MESSAGE);
				});
			}, function(error) {
				NotificationService.error($rootScope.labels.FILE_USER_SAVE_TWEET_ERROR_MESSAGE);
			});

		} else {
			NotificationService.info($rootScope.labels.FILE_USER_TWEET_TOO_LONG_ERROR_MESSAGE);
		}
	}

	$scope.reloadTweet = function() {
		if ($scope.loading_tweet == false) {
			$scope.loading_tweet = true;

			var paramsTweet = [
				{ key: encodeURIComponent("attribute[user_id]"), value: $scope.user.id },
				{ key: encodeURIComponent("order_by_desc[]"), value: "created_at" },
				{ key: "limit", value: 20 },
				{ key: "offset", value: $scope.tweets.length }
			];

			HTTPService.findTweet(paramsTweet).then(function(response) {
				$scope.tweets = $scope.tweets.concat(response.data.content);
				$timeout(function() {
					$scope.loading_tweet = false;
				}, 1000);
			}, function(error) {
				NotificationService.error("");
			});
		}
	}

	$scope.reloadPersonalTweet = function() {
		if ($scope.loading_tweet == false) {
			$scope.loading_tweet = true;

			var paramsTweet = [
				{ key: encodeURIComponent("attribute[user_id]"), value: $scope.user.id },
				{ key: encodeURIComponent("order_by_desc[]"), value: "created_at" },
				{ key: "limit", value: 20 },
				{ key: "offset", value: $scope.otherTweets.length },
				{ key: encodeURIComponent("attribute[msg]"), value: encodeURIComponent("%" + $scope.user.username + "%") }
			];

			HTTPService.findTweet(paramsTweet).then(function(response) {
				tmp_tweets = response.data.content;
				// Loop backward to splice inside
				for (var i = tmp_tweets.length - 1 ; i >= 0 ; i--) {
					if (tmp_tweets[i].user.id == id) {
						tmp_tweets.splice(i, 1);
					}
				}
				$scope.otherTweets = $scope.otherTweets.concat(tmp_tweets);
				$timeout(function() {
					$scope.loading_tweet = false;
				}, 1000);
			}, function(error) {
				NotificationService.error("");
			});
		}
	}

	$scope.selectFlux = function() { $scope.tab = 0; }
	$scope.selectInteraction = function() { $scope.tab = 1; }
}]);