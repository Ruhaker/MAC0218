require 'test_helper'

class CourseControllerTest < ActionDispatch::IntegrationTest
  test "should get enroll" do
    get course_enroll_url
    assert_response :success
  end

end
