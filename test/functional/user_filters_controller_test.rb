require 'test_helper'

class UserFiltersControllerTest < ActionController::TestCase
  test "should get update_filter" do
    get :update_filter
    assert_response :success
  end

  test "should get destroy_filter" do
    get :destroy_filter
    assert_response :success
  end

end
