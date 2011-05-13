require 'test_helper'

class MessageControllerTest < ActionController::TestCase
  test "should get inbox" do
    get :inbox
    assert_response :success
  end

  test "should get view" do
    get :view
    assert_response :success
  end

  test "should get compose" do
    get :compose
    assert_response :success
  end

end
