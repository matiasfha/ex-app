require 'test_helper'

class VideosControllerTest < ActionController::TestCase
  test "should get create_or_update_video" do
    get :create_or_update_video
    assert_response :success
  end

end
