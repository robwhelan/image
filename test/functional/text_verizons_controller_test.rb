require 'test_helper'

class TextVerizonsControllerTest < ActionController::TestCase
  setup do
    @text_verizon = text_verizons(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:text_verizons)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create text_verizon" do
    assert_difference('TextVerizon.count') do
      post :create, text_verizon: { text_contact_number: @text_verizon.text_contact_number, text_date: @text_verizon.text_date, text_direction: @text_verizon.text_direction, text_time: @text_verizon.text_time }
    end

    assert_redirected_to text_verizon_path(assigns(:text_verizon))
  end

  test "should show text_verizon" do
    get :show, id: @text_verizon
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @text_verizon
    assert_response :success
  end

  test "should update text_verizon" do
    put :update, id: @text_verizon, text_verizon: { text_contact_number: @text_verizon.text_contact_number, text_date: @text_verizon.text_date, text_direction: @text_verizon.text_direction, text_time: @text_verizon.text_time }
    assert_redirected_to text_verizon_path(assigns(:text_verizon))
  end

  test "should destroy text_verizon" do
    assert_difference('TextVerizon.count', -1) do
      delete :destroy, id: @text_verizon
    end

    assert_redirected_to text_verizons_path
  end
end
