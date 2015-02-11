/*

// This is called with the results from from FB.getLoginStatus().
function statusChangeCallback(response) {
	console.log(response);
  // The response object is returned with a status field that lets the
  // app know the current login status of the person.
  // Full docs on the response object can be found in the documentation
  // for FB.getLoginStatus().
  if (response.status === 'connected') {
  	testAPI();
  } else if (response.status === 'not_authorized') {
    // The person is logged into Facebook, but not your app.
    document.getElementById('status').innerHTML = 'Please log ' + 'into this app [not authorize].';
  } else {
    // The person is not logged into Facebook, so we're not sure if
    // they are logged into this app or not.
    document.getElementById('status').innerHTML = 'Please log ' + 'into Facebook.';
    $("#fb_log").onclick = function() {
	    FB.login(function(response) {
		  if (response.authResponse) {
		    // Logged into your app and Facebook.
		    testAPI();
		  } else {
		    console.log('User cancelled login or did not fully authorize.');
		  }
		});
	}
  }
}

//https://www.facebook.com/v2.1/dialog/oauth?scope=public_profile%2Cemail&response_type=none&redirect_uri=https%3A%2F%2Fwww.facebook.com%2Fdialog%2Freturn%2Farbiter%3Frelation%3Dopener%26close%3Dtrue%23origin%3Dhttp%253A%252F%252Flvh.me%253A3000%252Ffc14770c4&seen_revocable_perms_nux=false&ref=LoginButton&auth_type=&default_audience&state=f2f4e3523c&app_id=327968824079391&client_id=327968824079391

// This function is called when someone finishes with the Login
// Button.  See the onlogin handler attached to it in the sample
// code below.
function checkLoginState() {
  FB.getLoginStatus(function(response) {
    statusChangeCallback(response);
  });
}

window.fbAsyncInit = function() {
  FB.init({
    appId      : '327968824079391',
    cookie     : true,  // enable cookies to allow the server to access 
                        // the session
    xfbml      : true,  // parse social plugins on this page
    version    : 'v2.1' // use version 2.1
  });

  // Now that we've initialized the JavaScript SDK, we call 
  // FB.getLoginStatus().  This function gets the state of the
  // person visiting this page and can return one of three states to
  // the callback you provide.  They can be:
  //
  // 1. Logged into your app ('connected')
  // 2. Logged into Facebook, but not your app ('not_authorized')
  // 3. Not logged into Facebook and can't tell if they are logged into
  //    your app or not.
  //
  // These three cases are handled in the callback function.

  FB.getLoginStatus(function(response) {
    statusChangeCallback(response);
  });

};

// Load the SDK asynchronously
(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/fr_FR/sdk.js#xfbml=1&appId=327968824079391&version=v2.0";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));

// Here we run a very simple test of the Graph API after login is
// successful.  See statusChangeCallback() for when this call is made.
function testAPI() {
  FB.api('/me', function(response) {
    console.log('Successful login for: ' + response.name);
    document.getElementById('status').innerHTML =
      'Thanks for logging in, ' + response.name + '!';
  });
}

*/