require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  test "should get show_products" do
    get :show_products
    assert_response :success
  end

end
