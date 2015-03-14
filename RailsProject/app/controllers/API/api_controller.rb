# The module contain every class from the API
# It is used for the routing (for the subdomain)
module API
  # The class is the parent of every class because it is inherit from 'Apisecurity'
  # ApiController > ApisecurityController > any class of the API
  # Thanks to this, every class has the param into an attribute (params[:xxxx] => @xxx)
  class ApiController < ActionController::Base
    protect_from_forgery with: :null_session
    skip_before_filter  :verify_authenticity_token
    before_action :setParamToObj

    # Transform the params into attributes and create the getter to access it
    # 
    # ==== Options
    # 
    # * +:params+ - The GET or POST params, it is provided by rails as a global value.
    def setParamToObj
      keys = params.keys

      keys.each do |x|
        self.instance_variable_set("@#{x.to_s}", params[x])
        self.class.class_eval do
          define_method("get#{x.to_s.capitalize}") { params[x] }
        end
      end
      @httpCode = nil
    end
  end
end