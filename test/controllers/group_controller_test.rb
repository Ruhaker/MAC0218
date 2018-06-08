require 'test_helper'

class GroupControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get group_create_url
    assert_response :success
  end

  test "should get modify" do
    get group_modify_url
    assert_response :success
  end

  test "should get destroy" do
    get group_destroy_url
    assert_response :success
  end

end
