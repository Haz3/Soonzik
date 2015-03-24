require 'open-uri'

module API
  #
  # The class parent of every controller of the API.
  # It provides security and some default stuff
  class ApisecurityController < ApiController

    #
    # We create a list of code and initialize the returnValue and the security boolean.
    # Usually a controller has no constructor but in this case it's for the heritance.
    def initialize
      @security = false
      @returnValue = { content: [] }
      
      @code = []
      @code[200] = {code: 200, message: "Success"}
      @code[201] = {code: 201, message: "Created"}
      @code[202] = {code: 202, message: "NoContent"}
      @code[500] = {code: 500, message: "NotSecure"}
      @code[501] = {code: 501, message: "FailSecurity"}
      @code[502] = {code: 502, message: "NotFound"}
      @code[503] = {code: 503, message: "NotCreated"}
      @code[504] = {code: 504, message: "Error"}
      @code[505] = {code: 505, message: "UpdateError"}
    end

    #
    # Provide a token relative to the user who asks
    # Route : /getKey/:user_id [GET]
    #
    # ==== Options
    #
    # * +id+ - The id of the user who makes the transaction
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return { key: token_user }
    # - +404+ - Can't get an user with the id given
    # - +503+ - Error from server
    # 
    def provideKey
      if (defined?(@id))
        begin
          u = User.find_by_id(@id)
          @returnValue = {key: u.idAPI}
          codeAnswer 200
        rescue
          codeAnswer 504
          @httpCode = :service_unavailable
        end
      else
        codeAnswer 502
        @httpCode = :not_found
      end
      sendJson
    end

    #
    # To signin and get the information you need for the authentication
    # Route : /login [POST]
    # 
    # ==== Options
    # 
    # * +email+ - The email of the user
    # * +password+ - The password encrypted by the bcrypt algorithm
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return the user with ALL the field
    # - +404+ - Can't get an user with the email given or the combinaison is false
    # - +503+ - Error from server
    # 
    def login
      if (defined?(@email) && defined?(@password))
        begin
          user = User.find_by_email(@email)
          if (user && user.valid_password?(@password))
            codeAnswer 200
            @returnValue = { content: user.as_json(:include => {
                                                                  :address => {},
                                                                  :friends => {},
                                                                  :follows => {}
                                                                },
                                                    :only => User.notRestrictedKey
                                                  ) }
          else
            codeAnswer 502
            @httpCode = :not_found
          end
        rescue
          codeAnswer 504
          @httpCode = :service_unavailable
        end
      else
        codeAnswer 502
        @httpCode = :not_found
      end
      sendJson
    end

    #
    # Check if a facebook user is authenticate and retrive its informations
    # 
    # DEPRECATED FOR THE MOMENT
    #
    # Route : /loginFB/:token [POST]
    #
    # ==== Options
    # 
    # * +token+ - Token Facebook
    # * +email+ - GET variable -> The email of the user who provides the token
    # 
    # ===== HTTP VALUE
    # 
    # We don't care, it's deprecated
    # 
    def loginFB
      if (defined?(@email) && defined?(@token))
        begin
          url = "https://graph.facebook.com/oauth/access_token_info?access_token="
          uri = URI.parse(url + @token)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          request = Net::HTTP::Get.new(uri.request_uri)
          response = http.request(request)
          hash = JSON.parse(response.body)
          if (hash != nil && hash.has_key?("error"))
            codeAnswer 502
            @httpCode = :not_found
          else
            u = User.find_by(email: @email)
            if (u == nil)
              codeAnswer 502
              @httpCode = :not_found
            else
              @returnValue = { content: u.as_json(:include => :address) }
              codeAnswer 200
            end
          end
        rescue
          codeAnswer 504
          @httpCode = :service_unavailable
        end
      else
        codeAnswer 502
        @httpCode = :not_found
      end
      sendJson
    end

protected
    #
    # Check if the secure key corresponds to the key of the selected user.
    # This key is the hash between the token and the salt user.
    #
    # ==== Options
    #
    # * +user_id+ - The id of the user who makes the transaction
    # * +secureKey+ - The key provided to etablish a secure transaction
    #
    # ==== Example
    #
    #     # Assuming we have in database a user like this :
    #     #<User> -> id = 9
    #             -> idAPI = "6789"
    #             -> salt = "12345"
    #             -> securekey = SHA256(salt + idAPI)
    #     So if I provide :
    #             -> user_id = 9
    #             -> secureKey = SHA256("123456789")
    #     The access is granted and secure.
    #     If the hash is not good, the access is not granted.
    #
    # ===== HTTP VALUE
    # 
    # It is not a route so you can't query it, but if an issue happend, it can set the http code
    # - +401+ - The combination user_id / secureKey doesn't match, the access is not granted
    # - +503+ - Error from server
    # 
    def checkKey
      if (defined?(@user_id) && defined?(@secureKey))
        begin
          u = User.find_by_id(@user_id)
          if (@secureKey == u.secureKey)
            @security = true
            u.regenerateKey
            u.save
          else
            codeAnswer 501
            @httpCode = :unauthorized
          end
        rescue
          codeAnswer 504
          @httpCode = :service_unavailable
        end
      end
    end

    #
    # Render the value to return in json
    def sendJson
      codeAnswer(202) if defined?(@returnValue[:content]) && defined?(@returnValue[:content].size) && @returnValue[:content].size == 0
      defineHttp :ok if @httpCode == nil
      respond_to do |format|
        format.json { render :json => JSON.generate(@returnValue), :status => @httpCode }
      end
    end

    #
    # Put information about the answer (the code and the corresponding message) in the return value.
    # If a code has already been assigned, we don't modify it.
    #
    # ==== Attributes
    #
    # * +index+ - The index of the answer information
    #
    def codeAnswer(index)
      if (@returnValue[:code] != nil)
        return
      end

      if (@code[index] != nil)
        @returnValue[:code] = @code[index][:code]
        @returnValue[:message] = @code[index][:message]
      else
        @returnValue[:code] = 999
        @returnValue[:message] = "Unknow"
      end
    end

    #
    # Set the HTTP status
    # If a code has already been assigned, we don't modify it.
    #
    # ==== Attributes
    #
    # * +sym+ - The symbol of the http code
    #
    def defineHttp(sym)
      if (@httpCode == nil)
        @httpCode = sym
      end
    end
  end
end