SoonzikApp.controller('IndexCtrl', ['$scope', 'SecureAuth', 'HTTPService', '$routeParams', 'NotificationService', function ($scope, SecureAuth, HTTPService, $routeParams, NotificationService) {
	
	$scope.loading = true;
	$scope.currentUser = false;
	$scope.randomVote = [];
	$scope.votes = [
		{ value: 0, label: "" },
		{ value: 0, label: "" }
	];
	$scope.user = false;
	$scope.voteCurrentUser = false;

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
		$scope.user = false;

		/*
		**	Recupere les 3 dernieres news pour le slider.
		*/
		HTTPService.findNews([{ key: "order_by_desc[]", value: "date", limit: 3}]).then(function(news) {
			$scope.news = news.data.content;
			console.log($scope.news);

			/*
			**	 Recupere les 4 derniers packs mis en ligne.
			*/

			var parameters = [
				{ key: "limit", value: 4 },
				{ key: "order_by_asc[]", value: "created_at" }
			];

			/*$scope.imgPack = [
				{ "img": "http://upload.wikimedia.org/wikipedia/en/6/66/SallyCD.jpg"},
		        { "img": "http://upload.wikimedia.org/wikipedia/en/f/f1/Loureedtransformer.jpeg"},
		        { "img": "http://upload.wikimedia.org/wikipedia/en/7/70/Berlinloureed.jpeg"},
		        { "img": "http://upload.wikimedia.org/wikipedia/en/8/88/Lour72.jpg"},
		    ];*/

			HTTPService.findPacks(parameters).then(function (packs) {
				$scope.packs = packs.data.content;


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
								if ($scope.battle.votes[voteIndex].user_id == $scope.currentUser.id) {
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
	}

	$scope.indexVoteFor = function(battle, artist) {
		if ($scope.currentUser == false) {
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
						if ($scope.battle.votes[voteIndex].user_id == $scope.currentUser.id) {
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
}]);