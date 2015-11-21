module API
  # Controller which manage the transaction for the Feedbacks objects
  # Here is the list of action available :
  #
  # * index       [get]
  class FeedbacksController < ApisecurityController


    # Save a new object Feedback. For more information on the parameters, check at the model
    # 
    # Route : /feedbacks/save
    #
    # ==== Options
    # 
    # * +:feedback [email]+ - Mail to contact
    # * +:feedback [type_obj]+ - Type of the issue - Need to be one of this value : "bug", "payment", "account", "other"
    # * +:feedback [object]+ - Object of the feedback
    # * +:feedback [text]+ - Text of the feedback
    # 
    # ===== HTTP VALUE
    # 
    # - +201+ - In case of success, return the saved object including its musics (which includes its albums and artist) and user
    # - +503+ - Error from server
    # 
    def save
      begin
        feedback = Feedback.new(Feedback.feedback_params params)
        if (feedback.save)
          codeAnswer 201
          defineHttp :created
        else
          @returnValue = { content: feedback.errors.to_hash.to_json }
          codeAnswer 503
          defineHttp :service_unavailable
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end
  end
end