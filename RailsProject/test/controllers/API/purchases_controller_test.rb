require 'test_helper'

module API
  class PurchasesControllerTest < ActionController::TestCase
    def giveToken
      @user = users(:UserOne)
      return { id: @user.id, secureKey: @user.secureKey }
    end
    
    setup do
      @purchase = purchases(:PurchaseTwo)
    end

    test "should save purchase" do
      token = giveToken() # because of security access
      assert_difference('Purchase.count') do
        post :save, { purchase: { date: @purchase.date, obj_id: @purchase.obj_id, typeObj: @purchase.typeObj, user_id: @purchase.user_id }, user_id: token[:id], secureKey: token[:secureKey], format: :json }
      end
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 201
    end

    test "purchase of object which doesn't exist" do
      token = giveToken() # because of security access
      post :save, { purchase: { date: @purchase.date, obj_id: 1234, typeObj: @purchase.typeObj, user_id: @purchase.user_id }, user_id: token[:id], secureKey: token[:secureKey], format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 503
    end
  end
end