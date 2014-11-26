require 'test_helper'

module API
  class MessagesControllerTest < ActionController::TestCase
    setup do
      @message = messages(:MessageOne)
    end

    test "should save message" do
      assert_difference('Message.count') do
        post :save, { message: { dest_id: @message.dest_id, msg: @message.msg, session: @message.session, user_id: @message.user_id }, format: :json }
      end

      assert_redirected_to message_path(assigns(:message))
    end

    test "should show message ok" do
      get :show, { id: @message, format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
      assert_equal value["content"]["id"], @message.id
    end

    test "should show message ko" do
      get :show, id: 12345, format: :json
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 502
    end

    test "should get find - all cases" do
      get :find, { order_by_asc: ["id"], format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
      assert_equal value["content"].size, 2

      get :find, { offset: 42, order_by_asc: [], order_by_desc: ["id"], format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 202
      assert_equal value["content"].size, 0


      get :find, { limit: 1, offset: 0, attribute: { user_id: "%3%", dest_id: "655745983" }, order_by_asc: ["session"], order_by_desc: ["msg"], group_by: ["id"], format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
      assert_equal value["content"].size, 1
    end
  end
end