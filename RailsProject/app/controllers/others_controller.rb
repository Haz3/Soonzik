require 'open-uri'

class OthersController < ApplicationController
  include FormatsHelper

  def index
  	@user = session[:u]

  	#just for test
  	if (!session.has_key?(:u) && params.has_key?(:co) && params[:co].to_i == 1)
  	  session[:u] = User.first.attributes
  	elsif (params.has_key?(:co) && params[:co].to_i == 0)
  	  session.delete(:u)
  	end
  end

  def signin
  	
  end

  def facebook
    arg = { scope: "public_profile,email", response_type: "code", redirect_uri: DatasHelper.website_url + "oauth/callback", client_id: DatasHelper.facebook_app, state: "facebook" }
    redirect_to "https://www.facebook.com/v2.1/dialog/oauth" + format_get_params(arg)
  end

  def twitter
    arg = { oauth_callback: DatasHelper.website_url + "oauth/callback", oauth_nonce: "f38cd015447cce24e35e8107068e3204", oauth_signature: "kNhghGwwocqgPMnBktVaIY7jEMM%3D", oauth_signature_method: "HMAC-SHA1", oauth_token: "1951971955-TJuWAfR6awbG9ds1lEh9quuHzqtnx1xlRtORZD2", oauth_version: "1.0", oauth_timestamp: "1421350902" }
    redirect_to "https://api.twitter.com/oauth/request_token" + format_get_params(arg)
  end

  def google

  end

  def callback_oauth
    arg = { redirect_uri: DatasHelper.website_url + "oauth/callback", client_secret: DatasHelper.facebook_app_secret, code: params[:code] }# if twitter & g+ has a "code" callback parameter

    if (defined?params[:state] && params[:state] == "facebook")
      url = "https://graph.facebook.com/oauth/access_token"
      arg[:client_id] = DatasHelper.facebook_app
      uri = URI.parse(url + format_get_params(arg))
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)

      if ((matchData = /access_token=([A-Za-z0-9]+)&expires=([0-9]+)/.match(response.body)) != nil)
        session[:token] = matchData[1]

        url = "https://graph.facebook.com/me"
        uri = URI.parse(url + format_get_params({ access_token: matchData[1] }))
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)
        hash = JSON.parse(response.body)
        redirect_to activate_path(type: "facebook", token: matchData[1], email: hash["email"], firstname: hash["first_name"], lastname: hash["last_name"]) #activate social
      elsif (/error/.match(response.body) != nil)
        hash = JSON.parse(response.body)
        puts hash                         # a traiter
        redirect_to :root
      else
        redirect_to :root
      end
      return
    elsif (defined?params[:state] && params[:state] == "twitter")
      # for the moment
      redirect_to :root
    elsif (defined?params[:state] && params[:state] == "google")
      # for the moment
      redirect_to :root
    else

    end
  end

  def activate_account
    if (params.has_key?(:type) && params[:type] == "facebook" &&
        session.has_key?(:token) && params.has_key?(:token) && session[:token] == params[:token] &&
        params.has_key?(:email) && /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/.match(params[:email]) != nil)
      @email = params[:email]
      redirect_to action: "index", email: @email    # en vrai, render la vue d'activation
    else
      redirect_to action: "index", fail: true
    end
  end
end