require 'test_helper'

class EmailGmailsControllerTest < ActionController::TestCase
  setup do
    @email_gmail = email_gmails(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:email_gmails)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create email_gmail" do
    assert_difference('EmailGmail.count') do
      post :create, email_gmail: { contact_email: @email_gmail.contact_email, contact_name: @email_gmail.contact_name, date_sent: @email_gmail.date_sent, direction: @email_gmail.direction, message_id: @email_gmail.message_id, subject: @email_gmail.subject }
    end

    assert_redirected_to email_gmail_path(assigns(:email_gmail))
  end

  test "should show email_gmail" do
    get :show, id: @email_gmail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @email_gmail
    assert_response :success
  end

  test "should update email_gmail" do
    put :update, id: @email_gmail, email_gmail: { contact_email: @email_gmail.contact_email, contact_name: @email_gmail.contact_name, date_sent: @email_gmail.date_sent, direction: @email_gmail.direction, message_id: @email_gmail.message_id, subject: @email_gmail.subject }
    assert_redirected_to email_gmail_path(assigns(:email_gmail))
  end

  test "should destroy email_gmail" do
    assert_difference('EmailGmail.count', -1) do
      delete :destroy, id: @email_gmail
    end

    assert_redirected_to email_gmails_path
  end
end
