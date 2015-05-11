SoonzikApp.controller('UsersCtrl', ['$scope', "$routeParams", 'SecureAuth', 'HTTPService', 'NotificationService', '$timeout', function ($scope, $routeParams, SecureAuth, HTTPService, NotificationService, $timeout) {
	$scope.loading = true;

	$scope.show = {};
	$scope.form = { user: {} };


	// For the select of date
	$scope.currentYear = (new Date().getFullYear());
	$scope.months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
	$scope.days = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31];

	$scope.showInit = function () {
		var id = $routeParams.id;

		HTTPService.getProfile(id).then(function(profile) {
			/*- Begin get Profile -*/

			var dataProfile = profile.data.content;
			// Initialisation of the user profile
			$scope.show.user = {
				username: dataProfile.username,
				image: "/assets/" + dataProfile.image,
				facebook: linkToNothing(dataProfile.facebook),
				twitter: linkToNothing(dataProfile.twitter),
				googlePlus: linkToNothing(dataProfile.googlePlus)
			}


			HTTPService.isArtist(id).then(function(artistInformation) {
				/*- Begin isArtist -*/

				// Initialisation of the artist profile [if is one]
				$scope.show.user.isArtist = artistInformation.data.content.artist;
				if ($scope.show.user.isArtist == true) {
					$scope.show.user.topFive = artistInformation.data.content.topFive;
					$scope.show.user.albums = artistInformation.data.content.albums;
				}


				HTTPService.getFollowers(id).then(function(followersInformation) {
					/*- Begin getFollowers -*/

					// Load the followers of the user
					$scope.show.user.followers = followersInformation.data.content;

					// remove loading animation
					$scope.loading = false;
					NotificationService.success("The profile loaded perfectly");

					/*- End getFollowers -*/
				}, function(error) {
					// error management to do
					NotificationService.error("An error occured while loading the followers of this profile");
				});

				/*- End isArtist -*/
			}, function(error) {
				// error management to do
				NotificationService.error("An error occured while loading this profile");
			})

			/*- End get Profile -*/
		}, function(error) {
			// error management to do
			NotificationService.error("An error occured while loading this profile");
		});
	}

	function	linkToNothing(value) {
		if (value == null)
			return "#"
		else
			return value;
	}

	// ----

	$scope.editInit = function() {
		var id = $routeParams.id;
		var current_user = SecureAuth.getCurrentUser();

		$scope.function_submit = HTTPService.updateUser;

		if (current_user.id != id) {
			NotificationService.error("You can't edit this profile : it is not yours");
			$timeout(function() {
				document.location.pathname = "/";
			}, 1000);
		} else {
			HTTPService.getFullProfile(id).then(function(profile) {
				// Need a new route with security to get a profile with all informations
				var dataProfile = profile.data;

				// Initialisation of the user profile
				$scope.form.user = dataProfile;
				birthday = dataProfile.birthday.split('-');
				$scope.form.user.birthday = { year: 2000, month: 1, day: 1 };
				$scope.form.user.birthday.year = parseInt(birthday[0]);
				$scope.form.user.birthday.month = parseInt(birthday[1]);
				$scope.form.user.birthday.day = parseInt(birthday[2]);
				$scope.form.user.password = "";

				if (typeof $scope.form.user.address !== "undefined") {
					$scope.form.address = $scope.form.user.address;
					delete $scope.form.user.address;
				}

				// In the _form, Image & background need to be replaced by file uploader
				$scope.loading = false;
			}, function (error) {
				// error management to do
				NotificationService.error("An error occured while loading this profile");
			});
		}
	}

	$scope.submitForm = function() {
		SecureAuth.securedTransaction(function (key, user_id) {
			var parameters = { secureKey: key, user_id: user_id, user: jQuery.extend(true, {}, $scope.form.user) };
			delete parameters.user.username;
			if (typeof $scope.form.address !== "undefined") {
				parameters.address = $scope.form.address;
			}
			if (parameters.user.password.length == 0) {
				delete parameters.user.password;
			}
			$scope.function_submit(parameters).then(function(response) {
				console.log(response);
			}, function () {
				NotificationService.error("An error occured");
			});
		}, function () {
			NotificationService.error("An error occured");
		});
	}


	/* Utils function */

	$scope.range = function(n) {
  	return new Array(n);
  };

}]);