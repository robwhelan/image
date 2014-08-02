require 'test_helper'

class LinkedInInvitationsControllerTest < ActionController::TestCase
  setup do
    @linked_in_invitation = linked_in_invitations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:linked_in_invitations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create linked_in_invitation" do
    assert_difference('LinkedInInvitation.count') do
      post :create, linked_in_invitation: { accepted: @linked_in_invitation.accepted, date_sent: @linked_in_invitation.date_sent, initiator: @linked_in_invitation.initiator, invitation_id: @linked_in_invitation.invitation_id, name: @linked_in_invitation.name }
    end

    assert_redirected_to linked_in_invitation_path(assigns(:linked_in_invitation))
  end

  test "should show linked_in_invitation" do
    get :show, id: @linked_in_invitation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @linked_in_invitation
    assert_response :success
  end

  test "should update linked_in_invitation" do
    put :update, id: @linked_in_invitation, linked_in_invitation: { accepted: @linked_in_invitation.accepted, date_sent: @linked_in_invitation.date_sent, initiator: @linked_in_invitation.initiator, invitation_id: @linked_in_invitation.invitation_id, name: @linked_in_invitation.name }
    assert_redirected_to linked_in_invitation_path(assigns(:linked_in_invitation))
  end

  test "should destroy linked_in_invitation" do
    assert_difference('LinkedInInvitation.count', -1) do
      delete :destroy, id: @linked_in_invitation
    end

    assert_redirected_to linked_in_invitations_path
  end
end
