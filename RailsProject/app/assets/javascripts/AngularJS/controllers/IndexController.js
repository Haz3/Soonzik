SoonzikApp.controller('IndexCtrl', ['$scope', 'SecureAuth', 'HTTPService', '$routeParams', 'NotificationService', function ($scope, SecureAuth, HTTPService, $routeParams, NotificationService) {
	
	$scope.loading = true;
	$scope.index = { battles: [], votes: [], voteCurrentUser: [] };
	$scope.show = { battle: null, artistOne: {}, artistTwo: {}, voteCurrentUser: false, randomVote: [] };
	$scope.currentUser = false;

	/*
	**	Fonction d'init de foundation.
	**	+ Init Slider.
	*/

	$scope.initFoundation = function () {
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
	}

	/*
	**	ShowNews --> Recupere les 3 dernieres news pour le slider.
	*/

	$scope.showNews = function() {

		var parameters = [
			{ key: "order_by_desc[]", value: "date", limit: 3}
		];

		$scope.News = true;

		HTTPService.findNews(parameters).then(function(news) {
			
			$scope.news = news.data.content;

		}, function (error) {
			console.log("No News Available");
		})
	}

	/*
	**	ShowIndex --> Recupere les 4 derniers packs mis en ligne.
	*/

 	$scope.showIndex = function() {
		var parameters = [
			{ key: "limit", value: 4 },
			{ key: "order_by_asc[]", value: "created_at" }
		];

		$scope.showPack = true;

		$scope.imgPack = [
			{ "img": "http://upload.wikimedia.org/wikipedia/en/6/66/SallyCD.jpg"},
	        { "img": "http://upload.wikimedia.org/wikipedia/en/f/f1/Loureedtransformer.jpeg"},
	        { "img": "http://upload.wikimedia.org/wikipedia/en/7/70/Berlinloureed.jpeg"},
	        { "img": "http://upload.wikimedia.org/wikipedia/en/8/88/Lour72.jpg"},
	    ];

		HTTPService.findPacks(parameters).then(function (packs) {

			$scope.packs = packs.data.content;

		}, function (error) {
			console.log("There is no pack available");
		})
	}

	/*
	**	ShowBattleInfo --> Récupère la derniere battle mis en ligne.
	*/

	$scope.showBattleInfo = function() {
		var parameters = [
			{key: "order_by_desc[]", value: "created_at"},
			{key: "limit", value: 1}
		]

		$scope.showBattle = true;

		HTTPService.findBattles(parameters).then(function(response) {
			
			$scope.battle = response.data.content;
			console.log($scope.battle);

		}, function(error) {
			console.log("no battles available")
		})

	}

	$scope.showInit = function() {
		var id = $routeParams.id;
		var current_user = SecureAuth.getCurrentUser();
		if (current_user.id != null && current_user.token != null && current_user.username != null) {
			$scope.currentUser = current_user;
		}
		$scope.show.voteCurrentUser = false;
		HTTPService.showBattles(id).then(function(response) {
			console.log(response.data.content);
			$scope.show.battle = response.data.content;
			if ($scope.show.battle.votes.length > 0) {
				$scope.show.votes = [
					{ value: 0, label: $scope.show.battle.artist_one.username },
					{ value: 0, label: $scope.show.battle.artist_two.username }
				];
				for (var voteIndex in $scope.show.battle.votes) {
					if ($scope.show.battle.votes[voteIndex].artist_id == $scope.show.battle.artist_one.id) {
						$scope.show.votes[0].value++;
					} else {
						$scope.show.votes[1].value++;
					}
					if ($scope.show.battle.votes[voteIndex].user_id == $scope.currentUser.id) {
						$scope.show.voteCurrentUser = $scope.show.battle.votes[voteIndex].artist_id;
					}
				}
			} else {
				$scope.show.votes = false;
			}

			// Get top 5 of artists
			HTTPService.isArtist($scope.show.battle.artist_one.id).then(function(artistInformation) {
				/*- Begin isArtist - artist 1 -*/

				// Initialisation of the artist profile [if is one]
				var isArtist = artistInformation.data.content.artist;
				console.log(artistInformation);
				if (isArtist == true) {
					$scope.show.artistOne.topFive = artistInformation.data.content.topFive;
					$scope.show.artistOne.albums = artistInformation.data.content.albums;
				}

				HTTPService.isArtist($scope.show.battle.artist_two.id).then(function(artistInformation) {
					/*- Begin isArtist - artist 2 -*/

					// Initialisation of the artist profile [if is one]
					var isArtist = artistInformation.data.content.artist;
					if (isArtist == true) {
						$scope.show.artistTwo.topFive = artistInformation.data.content.topFive;
						$scope.show.artistTwo.albums = artistInformation.data.content.albums;
					}
					console.log("loading false");
					$scope.loading = false;
				}, function(error) {	// error management of the second isArtist
					NotificationService.error("Error while loading the profile of the second artist.")
				});
			}, function(error) {	// error management of the first isArtist
				NotificationService.error("Error while loading the profile of the first artist.");
			});

			console.log("random now :");
			randomPeople();

		}, function(error) {	// error management of the showBattle call
			NotificationService.error("An error occured while loading the page.")
		});
	}

	$scope.indexVoteFor = function(battle, artist) {
		var id = $routeParams.id;
		var current_user = SecureAuth.getCurrentUser();
		if (current_user.id != null && current_user.token != null && current_user.username != null) {
			$scope.currentUser = current_user;
		}
		$scope.show.voteCurrentUser = false;
		
		if ($scope.currentUser == false) {
			NotificationService.error("You need to be authenticated");
			return;
		}
		if ($scope.index.voteCurrentUser[battle.id] == false || $scope.index.voteCurrentUser[battle.id] != artist.id) {
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
					if ($scope.index.votes[battle.id].length == 0) {
						$scope.index.votes[battle.id] = [
							{ value: 0, label: battle.artist_one.username },
							{ value: 0, label: battle.artist_two.username }
						];
						oldVote = false;
					}
					$scope.index.voteCurrentUser[battle.id] = artist.id;

					// iterate on votes
					for (var battleIndex in $scope.index.battles) {
						// If this is the good battle
						if ($scope.index.battles[battleIndex].id == battle.id) {
							// Iterate on the votes
							for (var voteIndex in $scope.index.battles[battleIndex].votes) {
								// We modify the vote value
								if ($scope.index.battles[battleIndex].votes[voteIndex].user_id == $scope.currentUser.id) {
									$scope.index.battles[battleIndex].votes[voteIndex].artist_id = artist.id;
									
									// if you vote for the first
									if (artist.id == $scope.index.battles[battleIndex].artist_one.id) {
										$scope.index.votes[$scope.index.battles[battleIndex].id][0].value++;
										// if there is a previous vote, reduce the value for the other artist
										if (oldVote) {	$scope.index.votes[$scope.index.battles[battleIndex].id][1].value--;	}
									}
									else {		// if you vote for the second
										$scope.index.votes[$scope.index.battles[battleIndex].id][1].value++;
										// if there is a previous vote, reduce the value for the other artist
										if (oldVote) {	$scope.index.votes[$scope.index.battles[battleIndex].id][0].value--;	}
									}
								}
							}
						}
					}
				}, function(error) {
					NotificationService.error("An error occured while voting. Try again later.");
				});
			}, function(error) {
				NotificationService.error("An error occured while voting. Try again later.");
			});
		} else {
			NotificationService.info("This action is impossible : You already vote for this artist");
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

	$scope.loading = false;
}]);