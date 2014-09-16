module API
  class TweetsController < ApisecurityController
  	#index show save find destroy

  	# Retrieve all the tweets
    def index
      begin
        @returnValue = { content: Tweet.all.as_json(:include => :user) }
        if (@returnValue.size == 0)
          codeAnswer 202
        else
          codeAnswer 200
        end
      rescue
        codeAnswer 504
      end
      sendJson
    end

  	# Give a specific object by its id
    #
    # ==== Options
    # 
    # * +:id+ - The id of the specific tweets
    # 
    def show
      begin
        tweets = Tweet.find_by_id(@id)
        if (!tweets)
          codeAnswer 502
          return
        end
        @returnValue = { content: tweets.as_json(:include => :user) }
        codeAnswer 200
      rescue
        codeAnswer 504
      end
      sendJson
    end
  end
end