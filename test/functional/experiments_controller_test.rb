require 'test_helper'

class ExperimentsControllerTest < ActionController::TestCase
  test "should get create_or_update" do
    get :create_or_update
    assert_response :success
  end

end
