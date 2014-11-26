require 'test_helper'

module API
  class GiftsControllerTest < ActionController::TestCase
    setup do
      @gift = gifts(:cadeauUn)
    end

    test "should save gift" do
      assert_difference('Gift.count') do
        post :save, { gift: { from_user: @gift.from_user, obj_id: @gift.obj_id, to_user: @gift.to_user, typeObj: @gift.typeObj }, format: :json }
      end

      assert_redirected_to gift_path(assigns(:gift))
    end
  end
end