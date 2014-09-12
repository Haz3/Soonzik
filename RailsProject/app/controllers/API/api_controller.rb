module API
  class ApiController < ActionController::Base
    protect_from_forgery with: :null_session
    before_action :setParamToObj

    def setParamToObj
      keys = params.keys

      keys.each do |x|
        self.instance_variable_set("@#{x.to_s}", params[x])
        self.class.class_eval do
          define_method("get#{x.to_s.capitalize}") { params[x] }
        end
      end
    end
  end
end