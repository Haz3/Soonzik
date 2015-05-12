SoonzikApp.controller('UsersCtrl', ['$scope', "$routeParams", 'SecureAuth', 'HTTPService', 'NotificationService', '$timeout', function ($scope, $routeParams, SecureAuth, HTTPService, NotificationService, $timeout) {
	$scope.loading = true;

	$scope.show = {};
	$scope.form = { user: {} };
	$scope.formError = {
		user: {
			email: false,
			fname: false,
			lname: false,
			image: false,
			description: false,
			birthday: false,
			phoneNumber: false,
			facebook: false,
			twitter: false,
			googlePlus: false,
			newsletter: false,
			language: false,
			background: false,
			password: false
		},
		address: {
			numberStreet: false,
			complement: false,
			street: false,
			city: false,
			country: false,
			zipcode: false
		}
	};


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
				$scope.form.user["birthday(1i)"] = birthday[0];
				$scope.form.user["birthday(2i)"] = birthday[1];
				$scope.form.user["birthday(3i)"] = birthday[2];
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
			// We send this function to be executed after getting the secure key
			var parameters = { secureKey: key, user_id: user_id, user: jQuery.extend(true, {}, $scope.form.user) };//deep copy of the user object
			delete parameters.user.username; // it can't be modified
			if (typeof $scope.form.address !== "undefined") {
				parameters.address = $scope.form.address;
			}
			if (parameters.user.password.length == 0) {// we won't forced the user to put its password everytime
				delete parameters.user.password;
			}
			$scope.function_submit(parameters).then(function(response) {
				NotificationService.success("Profile updated successfully");
			}, function (responseError) {
				//if the update fail

				if (typeof responseError.data.content.user !== "undefined") {
					// Iterate on error
					for (var key in $scope.formError.user) {
						if (typeof responseError.data.content.user[key] !== "undefined") {
							$scope.formError.user[key] = responseError.data.content.user[key];
						} else {
							$scope.formError.user[key] = false;
						}
					}
				}
				if (typeof responseError.data.content.address !== "undefined") {
					// Iterate on error
					for (var key in $scope.formError.address) {
						if (typeof responseError.data.content.address[key] !== "undefined") {
							$scope.formError.address[key] = responseError.data.content.address[key];
						} else {
							$scope.formError.address[key] = false;
						}
					}
				}
				NotificationService.error("An error occured");
			});
		}, function (responseForbidden) {
			console.log(responseForbidden);
			NotificationService.error("An error occured");
		});
	}

	$scope.uploadAvatar = function($file) {
		console.log($file);
		if (files && files.length) {
			for (var i = 0; i < files.length; i++) {
				var file = files[i];
				// need to define a route to upload image

				/*Upload.upload({
					url: 'upload/url',
					fields: {'username': $scope.username},
					file: file
				}).progress(function (evt) {
				var progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
					console.log('progress: ' + progressPercentage + '% ' + evt.config.file.name);
				}).success(function (data, status, headers, config) {
					console.log('file ' + config.file.name + 'uploaded. Response: ' + data);
				});*/
			}
    }
	}

	$scope.uploadBackground = function($file) {
		console.log($file);
		if (files && files.length) {
			for (var i = 0; i < files.length; i++) {
				var file = files[i];
				// need to define a route to upload background

				/*Upload.upload({
					url: 'upload/url',
					fields: {'username': $scope.username},
					file: file
				}).progress(function (evt) {
				var progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
					console.log('progress: ' + progressPercentage + '% ' + evt.config.file.name);
				}).success(function (data, status, headers, config) {
					console.log('file ' + config.file.name + 'uploaded. Response: ' + data);
				});*/
			}
    }
	}

	/* Utils function */

	$scope.range = function(n) {
  	return new Array(n);
  };

}]);