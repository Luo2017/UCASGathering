require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get admin_show_url
    assert_response :success
  end

  test "should get delete" do
    get admin_delete_url
    assert_response :success
  end

  test "should get update" do
    get admin_update_url
    assert_response :success
  end

end
