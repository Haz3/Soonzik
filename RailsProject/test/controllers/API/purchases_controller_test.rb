require 'test_helper'

module API
  class PurchasesControllerTest < ActionController::TestCase
    setup do
      @purchase = purchases(:PurchaseOne)
    end

    test "should save purchase" do
      assert_difference('Purchase.count') do
        post :save, { purchase: { date: @purchase.date, obj_id: @purchase.obj_id, typeObj: @purchase.typeObj, user_id: @purchase.user_id }, format: :json }
      end

      assert_redirected_to purchase_path(assigns(:purchase))
    end
  end
end