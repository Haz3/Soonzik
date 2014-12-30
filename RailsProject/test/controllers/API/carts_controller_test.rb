require 'test_helper'

module API
  class CartsControllerTest < ActionController::TestCase
    def giveToken
      @user = users(:UserOne)
      return { id: @user.id, secureKey: @user.secureKey }
    end

    setup do
      @cart = carts(:panierUn)
    end

    test "should get find - all cases" do
      token = giveToken() # because of security access
      get :find, { order_by_asc: ["id"], user_id: token[:id], secureKey: token[:secureKey], format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
      assert_equal value["content"].size, 1

      token = giveToken() # because of security access
      get :find, { offset: 42, order_by_asc: [], order_by_desc: ["obj_id"], user_id: token[:id], secureKey: token[:secureKey], format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 202
      assert_equal value["content"].size, 0

      token = giveToken() # because of security access
      get :find, { limit: 1, offset: 0, attribute: { typeObj: "%Album%", gift: false }, order_by_asc: ["obj_id"], order_by_desc: ["user_id"], group_by: ["id"], user_id: token[:id], secureKey: token[:secureKey], format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
      assert_equal value["content"].size, 1
    end

    test "should save cart" do
      token = giveToken() # because of security access
      album = albums(:AlbumOne)
      assert_difference('Cart.count') do
        post :save, { id: @cart, cart: { gift: true, obj_id: album.id, typeObj: "Album", user_id: @cart.user_id }, user_id: token[:id], secureKey: token[:secureKey], format: :json }
      end
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 201
    end

    test "should destroy cart" do
      token = giveToken() # because of security access
      assert_difference('Cart.count', -1) do
        get :destroy, { id: @cart, user_id: token[:id], secureKey: token[:secureKey], format: :json}
      end
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 202
    end
  end
end