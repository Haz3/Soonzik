module API
  # The class parent of every controller of the API.
  # It provides security and some default stuff
  class ApisecurityController < ApiController
    after_action :sendJson, only: [:provideKey]

    # We create a list of code and initialize the returnValue and the security boolean.
    # Usually a controller has no constructor but in this case it's for the heritance.
    def initialize
      @security = false
      @returnValue = {}
      
      @code = []
      @code[200] = {code: 200, message: "Success"}
      @code[201] = {code: 201, message: "Created"}
      @code[202] = {code: 202, message: "NoContent"}
      @code[500] = {code: 500, message: "NotSecure"}
      @code[501] = {code: 501, message: "FailSecurity"}
      @code[502] = {code: 502, message: "NotFound"}
      @code[503] = {code: 503, message: "NotCreated"}
      @code[504] = {code: 504, message: "Error"}
    end

    # Provide a token relative to the user who asks
    #
    # ==== Options
    #
    # * +:user_id+ - The id of the user who makes the transaction
    #
    def provideKey
      if (defined?(@user_id))
        begin
          u = User.find_by_id(@user_id)
          @returnValue = {key: u.idAPI}
        rescue
        end
      end
    end

protected
    # Check if the secure key corresponds to the key of the selected user.
    # This key is the hash between the token and the salt user.
    #
    # ==== Options
    #
    # * +:user_id+ - The id of the user who makes the transaction
    # * +:secureKey+ - The key provided to etablish a secure transaction
    #
    # ==== Example
    #
    #     # Assuming we have in database a user like this :
    #     #<User> -> id = 9
    #             -> idAPI = "12345"
    #             -> salt = "6789"
    #             -> securekey = hash(idAPI + salt)
    #     So if I provide :
    #             -> user_id = 9
    #             -> secureKey = hash("123456789")
    #     The access is granted and secure.
    #     If the hash is not good, the access is not granted.
    #
    def checkKey
      if (defined?(@user_id) && defined?(@secureKey))
        begin
          u = User.find_by_id(@user_id)
          if (@secureKey == u.secureKey)
            @security = true
            u.regenerateKey
          end
        rescue
        end
      end
    end

    # Render the value to return in json
    def sendJson
      respond_to do |format|
        format.json { render :json => JSON.generate(@returnValue) }
      end
    end

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
  end
end