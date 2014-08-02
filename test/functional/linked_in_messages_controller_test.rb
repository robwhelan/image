require 'test_helper'

class LinkedInMessagesControllerTest < ActionController::TestCase
  setup do
    @linked_in_message = linked_in_messages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:linked_in_messages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create linked_in_message" do
    assert_difference('LinkedInMessage.count') do
      post :create, linked_in_message: { date_sent: @linked_in_message.date_sent, initiator: @linked_in_message.initiator, is_a_reply_to_outbound: @linked_in_message.is_a_reply_to_outbound, message_id: @linked_in_message.message_id, name: @linked_in_message.name }
    end

    assert_redirected_to linked_in_message_path(assigns(:linked_in_message))
  end

  test "should show linked_in_message" do
    get :show, id: @linked_in_message
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @linked_in_message
    assert_response :success
  end

  test "should update linked_in_message" do
    put :update, id: @linked_in_message, linked_in_message: { date_sent: @linked_in_message.date_sent, initiator: @linked_in_message.initiator, is_a_reply_to_outbound: @linked_in_message.is_a_reply_to_outbound, message_id: @linked_in_message.message_id, name: @linked_in_message.name }
    assert_redirected_to linked_in_message_path(assigns(:linked_in_message))
  end

  test "should destroy linked_in_message" do
    assert_difference('LinkedInMessage.count', -1) do
      delete :destroy, id: @linked_in_message
    end

    assert_redirected_to linked_in_messages_path
  end
end
