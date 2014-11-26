require 'test_helper'

class GiftTest < ActiveSupport::TestCase
  test "Public method of the model" do
    p1 = gifts(:cadeauUn)
    p2 = gifts(:cadeauDeux)

    music = musics(:MusicOne)

    assert_not p1.valid?
    assert p2.valid?
    
    p1.errors.clear
    p1.obj_id = music.id
    p1.typeObj = "Music"
    p1.objectValidation()
    assert_equal p1.errors.full_messages.size, 0

    p1.obj_id = 42
    p1.objectValidation()
    assert_equal p1.errors.full_messages.size, 1

    p2.typeObj = "FakeType"
    p2.objectValidation()
    assert_equal p2.errors.full_messages.size, 1
  end
end
