require 'test_helper'

module API
  class MessagesControllerTest < ActionController::TestCase
    def giveToken
      @user = users(:UserOne)
      return { id: @user.id, secureKey: @user.secureKey }
    end
    
    setup do
      @message = messages(:MessageOne)
    end

    test "should save message" do
      token = giveToken() # because of security access
      assert_difference('Message.count') do
        post :save, { message: { dest_id: @message.dest_id, msg: @message.msg, session: @message.session, user_id: @message.user_id }, user_id: token[:id], secureKey: token[:secureKey], format: :json }
      end
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 201
    end

    test "should show message ok" do
      token = giveToken() # because of security access
      get :show, { id: @message, user_id: token[:id], secureKey: token[:secureKey], format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
      assert_equal value["content"]["id"], @message.id
    end

    test "should show message ko" do
      token = giveToken() # because of security access
      get :show, id: 12345, user_id: token[:id], secureKey: token[:secureKey], format: :json
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 502
    end

    test "should get find - all cases" do
      token = giveToken() # because of security access
      get :find, { order_by_asc: ["id"], user_id: token[:id], secureKey: token[:secureKey], format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
      assert_equal value["content"].size, 1

      get :find, { offset: 42, order_by_asc: [], order_by_desc: ["id"], user_id: token[:id], secureKey: token[:secureKey], format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 202
      assert_equal value["content"].size, 0


      get :find, { limit: 1, offset: 0, attribute: { user_id: "%3%", dest_id: "655745983" }, order_by_asc: ["session"], order_by_desc: ["msg"], group_by: ["id"], user_id: token[:id], secureKey: token[:secureKey], format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
      assert_equal value["content"].size, 1
    end
  end
end