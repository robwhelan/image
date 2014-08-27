class NewCommsController < ApplicationController
  # GET /new_comms
  # GET /new_comms.json
  def index
    @new_comms = current_user.new_comms.order(:created_at).reverse

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @new_comms }
    end
  end

  # GET /new_comms/1
  # GET /new_comms/1.json
  def show
    @new_comm = NewComm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @new_comm }
    end
  end

  # GET /new_comms/new
  # GET /new_comms/new.json
  def new
    @new_comm = NewComm.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @new_comm }
    end
  end

  # GET /new_comms/1/edit
  def edit
    @new_comm = NewComm.find(params[:id])
  end

  # POST /new_comms
  # POST /new_comms.json
  def create
    @new_comm = NewComm.new(params[:new_comm])

    respond_to do |format|
      if @new_comm.save
        format.html { redirect_to @new_comm, notice: 'New comm was successfully created.' }
        format.json { render json: @new_comm, status: :created, location: @new_comm }
      else
        format.html { render action: "new" }
        format.json { render json: @new_comm.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /new_comms/1
  # PUT /new_comms/1.json
  def update
    @new_comm = NewComm.find(params[:id])

    respond_to do |format|
      if @new_comm.update_attributes(params[:new_comm])
        format.html { redirect_to @new_comm, notice: 'New comm was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @new_comm.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /new_comms/1
  # DELETE /new_comms/1.json
  def destroy
    @new_comm = NewComm.find(params[:id])
    @new_comm.destroy

    respond_to do |format|
      format.html { redirect_to new_comms_url }
      format.json { head :no_content }
    end
  end
end
