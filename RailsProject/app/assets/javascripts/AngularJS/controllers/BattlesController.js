SoonzikApp.controller('BattlesCtrl', ['$scope', "$routeParams", 'SecureAuth', 'HTTPService', 'NotificationService', function ($scope, $routeParams, SecureAuth, HTTPService, NotificationService) {
	$scope.loading = true;
	$scope.index = { battles: [], votes: [], voteCurrentUser: [] };
	$scope.show = {};
	$scope.currentUser = false;

	var BattlePerPage = 10;

	$scope.indexInit = function() {
		$scope.index.currentPage = (toInt($routeParams.page) == 0 ? 1 : toInt($routeParams.page));
		var current_user = SecureAuth.getCurrentUser();
		if (current_user.id != null && current_user.token != null && current_user.username != null) {
			$scope.currentUser = current_user;
		}

		var parameters = [
			{ key: "limit", value: BattlePerPage },
			{ key: "offset", value: (($scope.index.currentPage - 1) * BattlePerPage) },
			{ key: "order_by_desc[]", value: "created_at" }
		];
		
		HTTPService.indexBattles([{ key: "count", value: "true" }]).then(function(response) {
			var numberResults = response.data.content;

			if (typeof numberResults != "undefined") {
				$scope.index.numberPages = ~~(numberResults / BattlePerPage) + 1;
			} else {
				$scope.index.numberPages = 1;
			}

			HTTPService.findBattles(parameters).then(function(response) {
				$scope.index.battles = response.data.content;

				// For each battles
				for (var battleIndex in $scope.index.battles) {
					var votes = [
						{ value: 0, label: $scope.index.battles[battleIndex].artist_one.username },
						{ value: 0, label: $scope.index.battles[battleIndex].artist_two.username }
					];

					// For each votes
					for (var voteIndex in $scope.index.battles[battleIndex].votes) {
						// fill the votes object
						if ($scope.index.battles[battleIndex].votes[voteIndex].artist_id == $scope.index.battles[battleIndex].artist_one.id) {
							votes[0].value++;
						} else if ($scope.index.battles[battleIndex].votes[voteIndex].artist_id == $scope.index.battles[battleIndex].artist_two.id) {
							votes[1].value++;
						}

						// fill the vote array of the current user
						if ($scope.currentUser != false && $scope.index.battles[battleIndex].votes[voteIndex].user_id == $scope.currentUser.id) {
							$scope.index.voteCurrentUser[$scope.index.battles[battleIndex].id] = $scope.index.battles[battleIndex].votes[voteIndex].artist_id;
						}
					}

					// if no votes, no values
					if (votes[0].value == 0 && votes[1].value == 0) {
						$scope.index.votes[$scope.index.battles[battleIndex].id] = [];
					} else {
						$scope.index.votes[$scope.index.battles[battleIndex].id] = votes;
					}

					// if no vote for the current user
					if (typeof $scope.index.voteCurrentUser[$scope.index.battles[battleIndex].id] === "undefined") {
						$scope.index.voteCurrentUser[$scope.index.battles[battleIndex].id] = false;
					}

				}

				$scope.loading = false;
			}, function(error) {
				console.log(error);
			});
		}, function(error) {
			console.log(error);
		});		
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
			$scope.loading = false;
		}, function(error) {
			NotificationService.error("An error occured while loading the page")
		});
	}

	// callback vote

	$scope.indexVoteFor = function(battle, artist) {
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

	$scope.showVoteFor = function(battle, artist) {
		if ($scope.currentUser == false) {
			NotificationService.error("You need to be authenticated");
			return;
		}
		if ($scope.show.voteCurrentUser == false || $scope.show.voteCurrentUser != artist.id) {
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
					if ($scope.show.votes.length == 0) {
						$scope.show.votes = [
							{ value: 0, label: $scope.show.battle.artist_one.username },
							{ value: 0, label: $scope.show.battle.artist_two.username }
						];
						oldVote = false;
					}
					$scope.show.voteCurrentUser = artist.id;

					// Iterate on the votes
					for (var voteIndex in $scope.show.battle.votes) {
						// We modify the vote value
						if ($scope.show.battle.votes[voteIndex].user_id == $scope.currentUser.id) {
							$scope.show.battle.votes[voteIndex].artist_id = artist.id;
							
							// if you vote for the first
							if (artist.id == $scope.show.battle.artist_one.id) {
								$scope.show.votes[0].value++;
								// if there is a previous vote, reduce the value for the other artist
								if (oldVote) {	$scope.show.votes[1].value--;	}
							}
							else {		// if you vote for the second
								$scope.show.votes[1].value++;
								// if there is a previous vote, reduce the value for the other artist
								if (oldVote) {	$scope.show.votes[0].value--;	}
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
}]);