#require 'google_analytics_api'

class PagesController < ApplicationController
#  include GetCellData
#  include GetLinkedIn

  def save_vault
    gmail_username =      params[:gmail_username]
    gmail_password =      params[:gmail_password]
    linked_in_username =  params[:linked_in_email]
    linked_in_password =  params[:linked_in_password]
    verizon_primary =     params[:verizon_phone_primary]
    verizon_secret =      params[:verizon_secret_question]
    verizon_password =    params[:verizon_password]
    verizon_data =        params[:verizon_phone_account_data]
    vault_password =      params[:vault_password]
    
    current_user.set_encrypted_vault( gmail_username, gmail_password, linked_in_username, linked_in_password, verizon_primary, verizon_secret, verizon_password, verizon_data, vault_password)
    
    respond_to do |format|
      format.html { redirect_to pages_status_path, notice: 'Vault has been set. Update your data now!' }
    end
    
  end

  def update_data

    vault_password = params[:vault_password]
    count = current_user.new_comms.create
    count_record = count.id
    
    gmail_username =      AESCrypt.decrypt(current_user.encrypted_email_user, vault_password)
    gmail_password =      AESCrypt.decrypt(current_user.encrypted_email_password, vault_password)
    verizon_primary =     AESCrypt.decrypt(current_user.encrypted_verizon_primary, vault_password)
    verizon_secret =      AESCrypt.decrypt(current_user.encrypted_verizon_secret, vault_password)
    verizon_password =    AESCrypt.decrypt(current_user.encrypted_verizon_password, vault_password)
    verizon_data =        AESCrypt.decrypt(current_user.encrypted_verizon_data, vault_password)
    linked_in_username =  AESCrypt.decrypt(current_user.encrypted_linked_in_username, vault_password)
    linked_in_password =  AESCrypt.decrypt(current_user.encrypted_linked_in_password, vault_password)
    
    current_user.delay.get_gmail_messages("inbound", gmail_username, gmail_password, count_record)
    current_user.delay.get_gmail_messages("outbound", gmail_username, gmail_password, count_record)
    current_user.delay.get_texts(verizon_primary, verizon_secret, verizon_password, verizon_data, count_record)
    current_user.delay.get_calls(verizon_primary, verizon_secret, verizon_password, verizon_data, count_record)
    current_user.delay.get_invitations("inbound", linked_in_username, linked_in_password, count_record)
    current_user.delay.get_invitations("outbound", linked_in_username, linked_in_password, count_record)
    current_user.delay.get_messages("inbound", linked_in_username, linked_in_password, count_record)
    current_user.delay.get_messages("outbound", linked_in_username, linked_in_password, count_record)
    
    respond_to do |format|
      format.html { redirect_to new_comms_path, notice: 'Vault has been set. Update your data now!' }
    end
      
  end

  def synthesize_contacts
    @unassigned_phones = unique_phone_numbers
    @unassigned_emails = current_user.email_gmails.where(:contact_id => nil).uniq.order(:contact_email)
    @unassigned_linked_in_names = unique_linked_in_names
  end
  
  def build_contact
    email = params[:email]
    phone = params[:phone]
    linked_in = params[:linked_in]
    contact = current_user.contacts.create(
      :handle_email => email,
      :handle_phone => phone,
      :handle_linked_in => linked_in)
    flash[:notice] = "#{contact.handle_linked_in} created!"
    
      respond_to do |format|
        format.js
      end
  end
  
  def status
    @contacts = current_user.contacts_shown_as_actionable
    @ignored_contacts = current_user.contacts_shown_as_ignored

    if params[:tag]
      @contacts = @contacts.tagged_with(params[:tag])
      @ignored_contacts = @ignored_contacts.tagged_with(params[:tag])
      @tag = params[:tag]
    end
    
    @contacts_inbound = []
    @contacts_outbound = []
    
    get_open_comms(@contacts, @contacts_inbound, @contacts_outbound)
    @all_tags = current_user.owned_tags
  end

  def get_touchpoints
    @contact = Contact.find(params[:contact_id])
    @touchpoints = @contact.touchpoints.order(:touchpoint_date).reverse
    @tags = @contact.tags_from(current_user)
    #    @tags = @contact.tag_list
    #@all_tags = ActsAsTaggableOn::Tag.all
  end
  
  def add_tags
     @contact = Contact.find(params[:contact])
     current_user.tag_list.add(@contact, :with => params[:tags], :on => :tags)
#    @contact.save
      @tags = @contact.tags_from(current_user) # => ["paris", "normandy"]  end    
  end

private

  def get_open_comms(contacts, c_in, c_out)
    contacts.each do |contact|
      touch = contact.touchpoints.order(:touchpoint_date).last
      dir = touch.direction
      
      if dir == "Received"
        c_in << contact
      elsif dir == "inbound"
        c_in << contact
      elsif dir == "Sent"
        c_out << contact
      elsif dir == "outbound"
        c_out << contact
      end

    end
  end

  def unique_phone_numbers
    phones = []
    current_user.call_verizons.where(:contact_id => nil).each do |c|
      phones<<c.contact_number
    end
    current_user.text_verizons.where(:contact_id => nil).each do |t|
      phones<<t.text_contact_number
    end
    return phones.uniq.sort
  end

  def unique_linked_in_names
    linked_in_names = []
    current_user.linked_in_invitations.where(:contact_id => nil).each do |l|
      linked_in_names<<l.name
    end
    current_user.linked_in_messages.where(:contact_id => nil).each do |l|
      linked_in_names<<l.name
    end
    return linked_in_names.uniq.sort
  end

end