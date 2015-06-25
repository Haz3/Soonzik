using System;
using System.Diagnostics;
using Windows.ApplicationModel.Activation;
using Windows.Security.Authentication.Web;
using Facebook;

namespace SoonZik.Helpers
{
    public class FaceBookHelper
    {
        FacebookClient _fb = new FacebookClient();
        readonly Uri _callbackUri = WebAuthenticationBroker.GetCurrentApplicationCallbackUri();
        readonly Uri _loginUrl;
        private const string FacebookAppId = "383777021829578";//Enter your FaceBook App ID here  
        private const string FacebookPermissions = "user_about_me,read_stream,publish_actions";
        public string AccessToken
        {
            get { return _fb.AccessToken; }
        }

        public FaceBookHelper()
        {
            _loginUrl = _fb.GetLoginUrl(new
            {
                client_id = FacebookAppId,
                redirect_uri = _callbackUri.AbsoluteUri,
                scope = FacebookPermissions,
                display = "popup",
                response_type = "token"
            });
            Debug.WriteLine(_callbackUri);//This is useful for fill Windows Store ID in Facebook WebSite  
        }
        private void ValidateAndProccessResult(WebAuthenticationResult result)
        {
            if (result.ResponseStatus == WebAuthenticationStatus.Success)
            {
                var responseUri = new Uri(result.ResponseData.ToString());
                var facebookOAuthResult = _fb.ParseOAuthCallbackUrl(responseUri);

                if (string.IsNullOrWhiteSpace(facebookOAuthResult.Error))
                    _fb.AccessToken = facebookOAuthResult.AccessToken;
                else
                {//error de acceso denegado por cancelación en página  
                }
            }
            else if (result.ResponseStatus == WebAuthenticationStatus.ErrorHttp)
            {// error de http  
            }
            else
            {
                _fb.AccessToken = null;//Keep null when user signout from facebook  
            }
        }
        public void LoginAndContinue()
        {
            WebAuthenticationBroker.AuthenticateAndContinue(_loginUrl);
        }

        public void ContinueAuthentication(WebAuthenticationBrokerContinuationEventArgs args)
        {
            ValidateAndProccessResult(args.WebAuthenticationResult);
        }
    }
}