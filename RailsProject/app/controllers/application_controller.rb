class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :ensure_signup_complete#:authentication
  before_action :setControllerName

  before_filter :configure_permitted_parameters, if: :devise_controller?

=begin
  def authentication
  	begin
      if session.has_key?(:u) && !session[:u].is_a?(Hash)
        session.delete(:u)
      end

	  	if !session.has_key?(:u) && cookies.signed.has_key(:u)
  	    exp = cookies.signed[:u]
  	    if (exp.has_key?(:id) && exp.has_key?(:salt))
  	      u = User.find_by_id(exp[:id])
  	      if (u.salt == exp[:salt])
  	      	session[:u] = u
  	      end
  	    end
	  	end
 	  rescue
 	  	session.delete(:u)
 	  end

    if params.has_key?(:controller)
      @controller = params[:controller]
    else
      @controller = ""
    end
  end
=end

  def ensure_signup_complete
    # Ensure we don't go into an infinite loop
    return if action_name == 'finish_signup'

    # Redirect to the 'finish_signup' page if the user
    # email hasn't been verified yet
    if current_user && (!current_user.email_verified? || !current_user.username_verified?)
      redirect_to finish_signup_path(current_user)
    end
  end

  def setControllerName
    @controller = ""
    @controller = params[:controller] if params.has_key?(:controller)
  end


  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :fname, :lname, :username, :birthday, :image, :newsletter, :language) }
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password, :fname, :lname, :username, :birthday, :image, :description, :phoneNumber, :facebook, :twitter, :googlePlus, :newsletter, :language) }
    end
end
