class PagesController < ApplicationController
  include GetEmail
  include GetCellData
  include GetLinkedIn
  
  def update_gmail
    get_gmail_messages("inbound", current_user)
    get_gmail_messages("outbound", current_user)
  end
  
  def update_linked_in
    get_messages("inbound", current_user)
    get_messages("outbound", current_user)
    get_invitations("inbound", current_user)
    get_invitations("outbound", current_user)
  end
  
  def update_cell_data
    get_calls(current_user)
    get_texts(current_user)
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
    @contacts_inbound = []
    @contacts_outbound = []

    if params[:tag]
      @contacts = @contacts.tagged_with(params[:tag])
    end
    
    get_open_comms(@contacts, @contacts_inbound, @contacts_outbound)
    @all_tags = ActsAsTaggableOn::Tag.all
  end

  def get_touchpoints
    @contact = Contact.find(params[:contact_id])
    @touchpoints = @contact.touchpoints.order(:touchpoint_date).reverse
    @tags = @contact.tag_list
    @all_tags = ActsAsTaggableOn::Tag.all
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