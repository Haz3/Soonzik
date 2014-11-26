require 'test_helper'

module API
  class CartsControllerTest < ActionController::TestCase
    setup do
      @cart = carts(:panierUn)
    end

    test "should get find - all cases" do
      get :find, { order_by_asc: ["id"], format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
      assert_equal value["content"].size, 2

      get :find, { offset: 42, order_by_asc: [], order_by_desc: ["obj_id"], format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 202
      assert_equal value["content"].size, 0


      get :find, { limit: 1, offset: 0, attribute: { typeObj: "Music", user_id: "%3%" }, order_by_asc: ["obj_id"], order_by_desc: ["user_id"], group_by: ["id"], format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
      assert_equal value["content"].size, 1
    end

    test "should save cart" do
      assert_difference('Gift.count') do
        post :save, { id: @cart, cart: { gift: @cart.gift, obj_id: @cart.obj_id, typeObj: @cart.typeObj, user_id: @cart.user_id }, format: :json }
      end
      assert_redirected_to cart_path(assigns(:cart))
    end

    test "should destroy cart" do
      assert_difference('Cart.count', -1) do
        get :destroy, { id: @cart, format: :json}
      end

      assert_redirected_to carts_path
    end
  end
end