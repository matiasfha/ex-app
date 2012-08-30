require 'test_helper'

class QuestionsControllerTest < ActionController::TestCase
  test "should get update_question" do
    get :update_question
    assert_response :success
  end

  test "should get destroy_question" do
    get :destroy_question
    assert_response :success
  end

end
