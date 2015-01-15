class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authentication

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
end
