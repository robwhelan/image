class LinkedInMessagesController < ApplicationController
  # GET /linked_in_messages
  # GET /linked_in_messages.json
  def index
    @linked_in_messages = current_user.linked_in_messages.where(:batch_id => params[:batch])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @linked_in_messages }
    end
  end

  # GET /linked_in_messages/1
  # GET /linked_in_messages/1.json
  def show
    @linked_in_message = LinkedInMessage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @linked_in_message }
    end
  end

  # GET /linked_in_messages/new
  # GET /linked_in_messages/new.json
  def new
    @linked_in_message = LinkedInMessage.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @linked_in_message }
    end
  end

  # GET /linked_in_messages/1/edit
  def edit
    @linked_in_message = LinkedInMessage.find(params[:id])
  end

  # POST /linked_in_messages
  # POST /linked_in_messages.json
  def create
    @linked_in_message = LinkedInMessage.new(params[:linked_in_message])

    respond_to do |format|
      if @linked_in_message.save
        format.html { redirect_to @linked_in_message, notice: 'Linked in message was successfully created.' }
        format.json { render json: @linked_in_message, status: :created, location: @linked_in_message }
      else
        format.html { render action: "new" }
        format.json { render json: @linked_in_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /linked_in_messages/1
  # PUT /linked_in_messages/1.json
  def update
    @linked_in_message = LinkedInMessage.find(params[:id])

    respond_to do |format|
      if @linked_in_message.update_attributes(params[:linked_in_message])
        format.html { redirect_to @linked_in_message, notice: 'Linked in message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @linked_in_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /linked_in_messages/1
  # DELETE /linked_in_messages/1.json
  def destroy
    @linked_in_message = LinkedInMessage.find(params[:id])
    @linked_in_message.destroy

    respond_to do |format|
      format.html { redirect_to linked_in_messages_url }
      format.json { head :no_content }
    end
  end
end
