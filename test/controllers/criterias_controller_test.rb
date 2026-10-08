require "test_helper"

class CriteriasControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get criterias_new_url
    assert_response :success
  end

  test "should get show" do
    get criterias_show_url
    assert_response :success
  end

  test "should get create" do
    get criterias_create_url
    assert_response :success
  end
end
