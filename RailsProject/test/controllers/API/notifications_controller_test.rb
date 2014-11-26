require 'test_helper'

module API
  class NotificationsControllerTest < ActionController::TestCase
    setup do
      @notification = notifications(:NotifOne)
    end

    test "should save notification" do
      assert_difference('Notification.count') do
        post :save, { notification: { description: @notification.description, link: @notification.link, user_id: @notification.user_id }, format: :json }
      end

      assert_redirected_to notification_path(assigns(:notification))
    end

    test "should show notification ok" do
      get :show, { id: @notification, format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
      assert_equal value["content"]["id"], @notification.id
    end

    test "should show notification ko" do
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


      get :find, { limit: 1, offset: 0, attribute: { link: "%notification%", user_id: "213118761" }, order_by_asc: ["link"], order_by_desc: ["description"], group_by: ["id"], format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
      assert_equal value["content"].size, 1
    end

    test "should destroy notification" do
      assert_difference('Notification.count', -1) do
        get :destroy, { id: @notification, format: :json }
      end

      assert_redirected_to notifications_path
    end
  end
end