require 'test_helper'

module API
  class PlaylistsControllerTest < ActionController::TestCase
    setup do
      @playlist = playlists(:PlaylistOne)
    end

    test "should save playlist" do
      assert_difference('Playlist.count') do
        post :save, { playlist: { name: @playlist.name, user_id: @playlist.user_id }, format: :json }
      end

      assert_redirected_to playlist_path(assigns(:playlist))
    end

    test "should show playlist" do
      get :show, { id: @playlist, format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
      assert_equal value["content"]["id"], @playlist.id
    end

    test "should update playlist" do
      post :update, { id: @playlist, playlist: { name: @playlist.name, user_id: @playlist.user_id }, format: :json }
    end

    test "should destroy playlist" do
      assert_difference('Playlist.count', -1) do
        get :destroy, { id: @playlist, format: :json }
      end

      assert_redirected_to playlists_path
    end
  end
end