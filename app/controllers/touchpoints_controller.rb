class TouchpointsController < ApplicationController
  # GET /touchpoints
  # GET /touchpoints.json
  def index
    @touchpoints = current_user.touchpoints.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @touchpoints }
    end
  end

  # GET /touchpoints/1
  # GET /touchpoints/1.json
  def show
    @touchpoint = Touchpoint.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @touchpoint }
    end
  end

  # GET /touchpoints/new
  # GET /touchpoints/new.json
  def new
    @touchpoint = Touchpoint.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @touchpoint }
    end
  end

  # GET /touchpoints/1/edit
  def edit
    @touchpoint = Touchpoint.find(params[:id])
  end

  # POST /touchpoints
  # POST /touchpoints.json
  def create
    @touchpoint = Touchpoint.new(params[:touchpoint])

    respond_to do |format|
      if @touchpoint.save
        format.html { redirect_to @touchpoint, notice: 'Touchpoint was successfully created.' }
        format.json { render json: @touchpoint, status: :created, location: @touchpoint }
      else
        format.html { render action: "new" }
        format.json { render json: @touchpoint.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /touchpoints/1
  # PUT /touchpoints/1.json
  def update
    @touchpoint = Touchpoint.find(params[:id])

    respond_to do |format|
      if @touchpoint.update_attributes(params[:touchpoint])
        format.html { redirect_to @touchpoint, notice: 'Touchpoint was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @touchpoint.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /touchpoints/1
  # DELETE /touchpoints/1.json
  def destroy
    @touchpoint = Touchpoint.find(params[:id])
    @touchpoint.destroy

    respond_to do |format|
      format.html { redirect_to touchpoints_url }
      format.json { head :no_content }
    end
  end
end
