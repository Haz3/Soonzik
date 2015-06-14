SoonzikArtistApp = angular.module('SoonzikArtistApp', ['ngCookies', 'ngResource', 'ngFileUpload', 'ngAnimate']);

SoonzikArtistApp.config(['$httpProvider', function($httpProvider) {
  $httpProvider.defaults.useXDomain = true;
	delete $httpProvider.defaults.headers.common["X-Requested-With"];  
}]);