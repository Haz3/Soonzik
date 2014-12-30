require 'test_helper'

module API
  class GiftsControllerTest < ActionController::TestCase
    def giveToken
      @user = users(:UserOne)
      return { id: @user.id, secureKey: @user.secureKey }
    end
    
    setup do
      @gift = gifts(:cadeauDeux)
    end

    test "should save gift" do
      token = giveToken() # because of security access
      assert_difference('Gift.count') do
        post :save, { gift: { from_user: @gift.from_user, obj_id: @gift.obj_id, to_user: @gift.to_user, typeObj: @gift.typeObj }, user_id: token[:id], secureKey: token[:secureKey], format: :json }
      end
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 201
    end

    test "gift of object which doesn't exist" do
      token = giveToken() # because of security access
      post :save, { gift: { from_user: @gift.from_user, obj_id: 1234, to_user: @gift.to_user, typeObj: @gift.typeObj }, user_id: token[:id], secureKey: token[:secureKey], format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 503
    end
  end
end