require 'test_helper'

class ContactsControllerTest < ActionController::TestCase
  setup do
    @contact = contacts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contacts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create contact" do
    assert_difference('Contact.count') do
      post :create, contact: { address_1: @contact.address_1, address_2: @contact.address_2, city: @contact.city, first_name: @contact.first_name, handle_email: @contact.handle_email, handle_linked_in: @contact.handle_linked_in, handle_phone: @contact.handle_phone, last_name: @contact.last_name, zip_code: @contact.zip_code }
    end

    assert_redirected_to contact_path(assigns(:contact))
  end

  test "should show contact" do
    get :show, id: @contact
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @contact
    assert_response :success
  end

  test "should update contact" do
    put :update, id: @contact, contact: { address_1: @contact.address_1, address_2: @contact.address_2, city: @contact.city, first_name: @contact.first_name, handle_email: @contact.handle_email, handle_linked_in: @contact.handle_linked_in, handle_phone: @contact.handle_phone, last_name: @contact.last_name, zip_code: @contact.zip_code }
    assert_redirected_to contact_path(assigns(:contact))
  end

  test "should destroy contact" do
    assert_difference('Contact.count', -1) do
      delete :destroy, id: @contact
    end

    assert_redirected_to contacts_path
  end
end
