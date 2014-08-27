require 'test_helper'

class NewCommsControllerTest < ActionController::TestCase
  setup do
    @new_comm = new_comms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:new_comms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create new_comm" do
    assert_difference('NewComm.count') do
      post :create, new_comm: { call_in: @new_comm.call_in, call_out: @new_comm.call_out, email_in: @new_comm.email_in, email_out: @new_comm.email_out, li_invite_in: @new_comm.li_invite_in, li_invite_out: @new_comm.li_invite_out, li_message_in: @new_comm.li_message_in, li_message_out: @new_comm.li_message_out, text_in: @new_comm.text_in, text_out: @new_comm.text_out }
    end

    assert_redirected_to new_comm_path(assigns(:new_comm))
  end

  test "should show new_comm" do
    get :show, id: @new_comm
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @new_comm
    assert_response :success
  end

  test "should update new_comm" do
    put :update, id: @new_comm, new_comm: { call_in: @new_comm.call_in, call_out: @new_comm.call_out, email_in: @new_comm.email_in, email_out: @new_comm.email_out, li_invite_in: @new_comm.li_invite_in, li_invite_out: @new_comm.li_invite_out, li_message_in: @new_comm.li_message_in, li_message_out: @new_comm.li_message_out, text_in: @new_comm.text_in, text_out: @new_comm.text_out }
    assert_redirected_to new_comm_path(assigns(:new_comm))
  end

  test "should destroy new_comm" do
    assert_difference('NewComm.count', -1) do
      delete :destroy, id: @new_comm
    end

    assert_redirected_to new_comms_path
  end
end
