class CallVerizonsController < ApplicationController
  # GET /call_verizons
  # GET /call_verizons.json
  def index
    @call_verizons = CallVerizon.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @call_verizons }
    end
  end

  # GET /call_verizons/1
  # GET /call_verizons/1.json
  def show
    @call_verizon = CallVerizon.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @call_verizon }
    end
  end

  # GET /call_verizons/new
  # GET /call_verizons/new.json
  def new
    @call_verizon = CallVerizon.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @call_verizon }
    end
  end

  # GET /call_verizons/1/edit
  def edit
    @call_verizon = CallVerizon.find(params[:id])
  end

  # POST /call_verizons
  # POST /call_verizons.json
  def create
    @call_verizon = CallVerizon.new(params[:call_verizon])

    respond_to do |format|
      if @call_verizon.save
        format.html { redirect_to @call_verizon, notice: 'Call verizon was successfully created.' }
        format.json { render json: @call_verizon, status: :created, location: @call_verizon }
      else
        format.html { render action: "new" }
        format.json { render json: @call_verizon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /call_verizons/1
  # PUT /call_verizons/1.json
  def update
    @call_verizon = CallVerizon.find(params[:id])

    respond_to do |format|
      if @call_verizon.update_attributes(params[:call_verizon])
        format.html { redirect_to @call_verizon, notice: 'Call verizon was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @call_verizon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /call_verizons/1
  # DELETE /call_verizons/1.json
  def destroy
    @call_verizon = CallVerizon.find(params[:id])
    @call_verizon.destroy

    respond_to do |format|
      format.html { redirect_to call_verizons_url }
      format.json { head :no_content }
    end
  end
end
