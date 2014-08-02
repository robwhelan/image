require 'test_helper'

class CallVerizonsControllerTest < ActionController::TestCase
  setup do
    @call_verizon = call_verizons(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:call_verizons)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create call_verizon" do
    assert_difference('CallVerizon.count') do
      post :create, call_verizon: { call_date: @call_verizon.call_date, call_direction: @call_verizon.call_direction, call_duration: @call_verizon.call_duration, call_time: @call_verizon.call_time, contact_number: @call_verizon.contact_number }
    end

    assert_redirected_to call_verizon_path(assigns(:call_verizon))
  end

  test "should show call_verizon" do
    get :show, id: @call_verizon
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @call_verizon
    assert_response :success
  end

  test "should update call_verizon" do
    put :update, id: @call_verizon, call_verizon: { call_date: @call_verizon.call_date, call_direction: @call_verizon.call_direction, call_duration: @call_verizon.call_duration, call_time: @call_verizon.call_time, contact_number: @call_verizon.contact_number }
    assert_redirected_to call_verizon_path(assigns(:call_verizon))
  end

  test "should destroy call_verizon" do
    assert_difference('CallVerizon.count', -1) do
      delete :destroy, id: @call_verizon
    end

    assert_redirected_to call_verizons_path
  end
end
