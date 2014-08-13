require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get synthesize_contacts" do
    get :synthesize_contacts
    assert_response :success
  end

end
