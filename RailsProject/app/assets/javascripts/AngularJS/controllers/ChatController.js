SoonzikApp.controller('ChatCtrl', ['$scope', 'SecureAuth', 'HTTPService', '$timeout', function ($scope, SecureAuth, HTTPService, $timeout) {
	var sizeChatWindow = 260;

	$scope.current_user = SecureAuth.getCurrentUser();
	$scope.filter = { username: "" }
	$scope.friends = [];
	$scope.onWindows = [];
	$scope.message = {};
	$scope.onlineFriends = []
	$scope.showMiniWindow = { value: false };

	$scope.conversationStyle = { width: "auto" }

	var onlineFriendsCall = false;
	var listFriendsCall = false;
	var timeSynchronizationCall = 200;

	/* BEGIN/ Websocket logic */
	
	var dispatcher = new WebSocketRails('lvh.me:3000/websocket');

	dispatcher.on_open = function(data) {
		dispatcher.trigger('who_is_online', "");
		dispatcher.bind('onlineFriends', function(data) {
	    $scope.onlineFriends = data.message;
	    onlineFriendsCall = true;
	  });
	  dispatcher.bind("newMsg", newMessage);
	  dispatcher.bind("newOnlineFriends", newFriendOn);
	  dispatcher.bind("newOfflineFriends", newFriendOff);
	}

	var newMessage = function(data) {
		if (typeof data !== "undefined" &&
				typeof data.from !== "undefined") {

			if ((typeof $scope.message[data.from] == "undefined" && isInFriendList(data.from) != false) ||
					(typeof $scope.message[data.from] != "undefined" && isOpen(data.from))) {
				$scope.open_chat(isInFriendList(data.from));
			} else if (typeof $scope.message[data.from] == "undefined" && isInFriendList(data.from) == false) {
				return;
			}
			$scope.message[data.from].messagesText.push({ extern: true, value: data.message });
	    $scope.$digest();
  	}
	}

	var newFriendOn = function(data) {
		for (var index in $scope.friends) {
			if ($scope.friends[index].id == data.idFriend && $scope.friends[index].online == false) {
				$scope.friends[index].online = true;
	    	$scope.$digest();
				return;
			}
		}
	}

	var newFriendOff = function(data) {
		for (var index in $scope.friends) {
			if ($scope.friends[index].id == data.idFriend && $scope.friends[index].online == true) {
				$scope.friends[index].online = false;
	    	$scope.$digest();
				return;
			}
		}
	}

	// check les gens qui passe en ligne / hors ligne grace à l'event de connexion
	// -> Prendre en compte les onlines / offline (bouger d'objet)
	// -> Charger les derniers messages

	/*-- END/ Websocket logic --*/

	//-------------------------------------------------------------------

	/* Private method */

	var canItBeBig = function (arrayWindows) {
		var width = $(window).width() - 320;	// 320 = 210 (size of friend list) + margin left of the screen
		var numberMaxWindowOpened = ~~(width / sizeChatWindow);
		var currentlyOpened = 0;

		for (var index in arrayWindows) {
			if (arrayWindows[index].opened == true && arrayWindows[index].maximized == true)
				currentlyOpened++;
		}
		if (currentlyOpened >= numberMaxWindowOpened)
			return false;
		return true;
	}

	var calcWidth = function (arrayWindows) {
		var width = 0;
		var miniWindow = false;

		for (var index in arrayWindows) {
			if (arrayWindows[index].maximized == true && arrayWindows[index].opened == true)
				width += 260;
			else if (arrayWindows[index].maximized == false && arrayWindows[index].opened == true)
				miniWindow = true;
		}

		$scope.conversationStyle.width = width + (miniWindow ? 45 : 0);
	}

	var isInFriendList = function (from_username) {
		for (var index in $scope.friends) {
			if ($scope.friends[index].username == from_username) {
				return $scope.friends[index];
			}
		}
		return false;
	}

	var timeoutSynchronization = function () {
		if (onlineFriendsCall == true && listFriendsCall == true) {
			for (var index in $scope.friends) {
				for (var indexOnline in $scope.onlineFriends) {
					if ($scope.friends[index].id == $scope.onlineFriends[indexOnline]) {
						$scope.friends[index].online = true;
					}
				}
			}
		} else {
			timeSynchronizationCall += 150;
			$timeout(timeoutSynchronization, timeSynchronizationCall);
		}
	}

	var isOpen = function(username) {
		for (var index in $scope.friends) {
			if ($scope.friends[index].friend == username && $scope.friends[index].opened == false) {
				return false;
			}
		}
		return true;
	}

	//-------------------------------------------------------------------

	/*-- BEGIN/ Angular callback --*/

	// ng-init call
	$scope.chatInit = function() {
		HTTPService.getFriends($scope.current_user.id).then(function(friendsResponse) {
			$scope.friends = friendsResponse.data.content;
			for (var index in $scope.friends) {
				$scope.friends[index].online = false;
			}
			listFriendsCall = true;
		}, function(error) {
			console.log(error);
		});
	}

	// ng-click call
	$scope.open_chat = function(friend) {
		var selectedObject = null;
		for (var index in $scope.onWindows) {
			if ($scope.onWindows[index].friend.id == friend.id) {
				selectedObject = $scope.onWindows[index];
			}
		}

		var big = canItBeBig($scope.onWindows);

		if (big == false) {
			for (var index in $scope.onWindows) {
				if ($scope.onWindows[index].friend.id != friend.id) {
					$scope.onWindows[index].maximized = false;
				}
			}
		}

		if (selectedObject == null) {
			selectedObject = {
				friend: friend,
				maximized: true,
				opened: true
			};
			$scope.onWindows.push(selectedObject);
			$scope.message[friend.username] = { value: "", messagesText: [] };
		} else {
			selectedObject.opened = true;
			selectedObject.maximized = true;
		}

		calcWidth($scope.onWindows);
	}

	// submit-input call
	$scope.sendMsg = function(friend) {
		var isThereChar = false;

		for (var i = 0 ; i < $scope.message[friend.username].value.length ; i++) {
			if ($scope.message[friend.username].value[i] != ' ' && $scope.message[friend.username].value[i] != '\t') {
				isThereChar = true;
				break;
			}
		}

		if (isThereChar != false && $scope.message[friend.username].value.length > 0) {
			var sendMsg = {
				messageValue: $scope.message[friend.username].value,
				toWho: friend.id
			}
			$scope.message[friend.username].messagesText.push({ extern: false, value: sendMsg.messageValue });
			dispatcher.trigger('messages.send', sendMsg)
		}
		$scope.message[friend.username].value = "";
		$scope.$digest();
	}

	// Synchronize informations
	$timeout(timeoutSynchronization, timeSynchronizationCall);

	// ng-click call
	$scope.closeChat = function(friendWindow) {
		friendWindow.opened = false;
		friendWindow.maximized = true;

		var nbConv = 0;

		for (var index in $scope.onWindows) {
			if ($scope.onWindows[index].opened == true && $scope.onWindows[index].maximized == true) {
				nbConv++;
			}
		}

		if (nbConv == 0 && $scope.miniChat().length > 0) {
			for (var index in $scope.onWindows) {
				if ($scope.onWindows[index].opened == true && $scope.onWindows[index].maximized == false) {
					$scope.onWindows[index].maximized = true;
				}
			}
		}


		calcWidth($scope.onWindows);
	}

	// click-click call
	$scope.openMiniChat = function() {
		$scope.showMiniWindow.value = true;
	}

	// click-outside call
	$scope.closeMiniChat = function() {
		$scope.showMiniWindow.value = false;
	}

	// ng-if call
	$scope.miniChat = function() {
		var list = []
		for (var index in $scope.onWindows) {
			if ($scope.onWindows[index].opened == true && $scope.onWindows[index].maximized == false) {
				list.push($scope.onWindows[index]);
			}
		}
		return list;
	}

	/*-- END/ Angular callback --*/
}]);