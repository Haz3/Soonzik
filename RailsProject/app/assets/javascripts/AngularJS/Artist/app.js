SoonzikArtistApp = angular.module('SoonzikArtistApp', ['ngCookies', 'ngResource', 'ngFileUpload', 'ngAnimate', 'mm.foundation', 'checklist-model']);

SoonzikArtistApp.config(['$httpProvider', function($httpProvider) {
  $httpProvider.defaults.useXDomain = true;
	delete $httpProvider.defaults.headers.common["X-Requested-With"];  
}]);