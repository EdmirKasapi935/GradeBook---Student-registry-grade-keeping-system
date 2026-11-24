require "test_helper"

class AssessmentItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get assessment_items_index_url
    assert_response :success
  end

  test "should get new" do
    get assessment_items_new_url
    assert_response :success
  end

  test "should get edit" do
    get assessment_items_edit_url
    assert_response :success
  end
end
