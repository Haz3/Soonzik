require 'test_helper'

module API
  class UsersControllerTest < ActionController::TestCase
    setup do
      @user = users(:UserOne)
    end

    test "should get index" do
      get :index, format: :json
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
    end

    test "should save user" do
      assert_difference('User.count') do
        post :save, { user: { activated: @user.activated, address_id: @user.address_id, birthday: @user.birthday, description: @user.description, email: @user.email, facebook: @user.facebook, fname: @user.fname, googlePlus: @user.googlePlus, idAPI: @user.idAPI, image: @user.image, language: @user.language, lname: @user.lname, newsletter: @user.newsletter, password: @user.password, phoneNumber: @user.phoneNumber, salt: @user.salt, secureKey: @user.secureKey, signin: @user.signin, twitter: @user.twitter, username: @user.username }, format: :json }
      end

      #assert_redirected_to user_path(assigns(:user))
    end

    test "should show user" do
      get :show, { id: @user, format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
      assert_equal value["content"]["id"], @user.id
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


      get :find, { limit: 1, offset: 0, attribute: { username: "%test%", fname: "first name" }, order_by_asc: ["msg"], order_by_desc: ["description"], group_by: ["twitter"], format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
      assert_equal value["content"].size, 1
    end

    test "should update user" do
      post :update, { id: @user, user: { activated: @user.activated, address_id: @user.address_id, birthday: @user.birthday, description: @user.description, email: @user.email, facebook: @user.facebook, fname: @user.fname, googlePlus: @user.googlePlus, idAPI: @user.idAPI, image: @user.image, language: @user.language, lname: @user.lname, newsletter: @user.newsletter, password: @user.password, phoneNumber: @user.phoneNumber, salt: @user.salt, secureKey: @user.secureKey, signin: @user.signin, twitter: @user.twitter, username: @user.username }, format: :json }
    end

    test "should get musics of user" do
      get :getmusics, { id: @user, format: :json }
      assert_response :success
    end
  end
end