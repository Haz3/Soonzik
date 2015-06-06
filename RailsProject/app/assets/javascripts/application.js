// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require foundation
//= require ./player/wavesurfer.min.js
//= require ./player/main.js
//= require ./tools/sha256.js
//= require ./tools/messenger.min.js
//= require ./tools/messenger-theme-future.js
//= require ./tools/raphael-min.js
//= require ./tools/morris.min.js
//= require angular
//= require angular-animate
//= require angular-cookies
//= require angular-route
//= require angular-resource
//= require ./AngularJS/app.js.erb
//= require ./AngularJS/controllers/ChatController.js
//= require ./AngularJS/controllers/BattlesController.js
//= require ./AngularJS/controllers/UsersController.js
//= require ./AngularJS/controllers/IndexController.js
//= require ./AngularJS/controllers/PlayerController.js
//= require ./AngularJS/directives/autofocus.js
//= require ./AngularJS/directives/autoscrollbottom.js
//= require ./AngularJS/directives/battle.js
//= require ./AngularJS/directives/clickOutside.js
//= require ./AngularJS/directives/loading.js
//= require ./AngularJS/directives/music.js
//= require ./AngularJS/directives/onScroll.js
//= require ./AngularJS/directives/selectOnClick.js
//= require ./AngularJS/directives/submitInput.js
//= require ./AngularJS/directives/wavesurfer.js
//= require ./AngularJS/services/SecureAuth.js
//= require ./AngularJS/services/HTTPService.js
//= require ./AngularJS/services/NotificationService.js
//= require ./tools/ng-file-upload-bower-4.2.0/ng-file-upload-all.min.js
// require_tree .

$(function(){ $(document).foundation(); });