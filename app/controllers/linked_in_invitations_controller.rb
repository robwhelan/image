class LinkedInInvitationsController < ApplicationController
  # GET /linked_in_invitations
  # GET /linked_in_invitations.json
  def index
    @linked_in_invitations = current_user.linked_in_inviations.where(:batch_id => params[:batch_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @linked_in_invitations }
    end
  end

  # GET /linked_in_invitations/1
  # GET /linked_in_invitations/1.json
  def show
    @linked_in_invitation = LinkedInInvitation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @linked_in_invitation }
    end
  end

  # GET /linked_in_invitations/new
  # GET /linked_in_invitations/new.json
  def new
    @linked_in_invitation = LinkedInInvitation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @linked_in_invitation }
    end
  end

  # GET /linked_in_invitations/1/edit
  def edit
    @linked_in_invitation = LinkedInInvitation.find(params[:id])
  end

  # POST /linked_in_invitations
  # POST /linked_in_invitations.json
  def create
    @linked_in_invitation = LinkedInInvitation.new(params[:linked_in_invitation])

    respond_to do |format|
      if @linked_in_invitation.save
        format.html { redirect_to @linked_in_invitation, notice: 'Linked in invitation was successfully created.' }
        format.json { render json: @linked_in_invitation, status: :created, location: @linked_in_invitation }
      else
        format.html { render action: "new" }
        format.json { render json: @linked_in_invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /linked_in_invitations/1
  # PUT /linked_in_invitations/1.json
  def update
    @linked_in_invitation = LinkedInInvitation.find(params[:id])

    respond_to do |format|
      if @linked_in_invitation.update_attributes(params[:linked_in_invitation])
        format.html { redirect_to @linked_in_invitation, notice: 'Linked in invitation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @linked_in_invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /linked_in_invitations/1
  # DELETE /linked_in_invitations/1.json
  def destroy
    @linked_in_invitation = LinkedInInvitation.find(params[:id])
    @linked_in_invitation.destroy

    respond_to do |format|
      format.html { redirect_to linked_in_invitations_url }
      format.json { head :no_content }
    end
  end
end
