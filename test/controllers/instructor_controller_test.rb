require "test_helper"

class InstructorControllerTest < ActionDispatch::IntegrationTest
  test "should get dashboard" do
    get instructor_dashboard_url
    assert_response :success
  end
end
