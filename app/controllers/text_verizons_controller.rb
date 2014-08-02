class TextVerizonsController < ApplicationController
  # GET /text_verizons
  # GET /text_verizons.json
  def index
    @text_verizons = TextVerizon.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @text_verizons }
    end
  end

  # GET /text_verizons/1
  # GET /text_verizons/1.json
  def show
    @text_verizon = TextVerizon.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @text_verizon }
    end
  end

  # GET /text_verizons/new
  # GET /text_verizons/new.json
  def new
    @text_verizon = TextVerizon.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @text_verizon }
    end
  end

  # GET /text_verizons/1/edit
  def edit
    @text_verizon = TextVerizon.find(params[:id])
  end

  # POST /text_verizons
  # POST /text_verizons.json
  def create
    @text_verizon = TextVerizon.new(params[:text_verizon])

    respond_to do |format|
      if @text_verizon.save
        format.html { redirect_to @text_verizon, notice: 'Text verizon was successfully created.' }
        format.json { render json: @text_verizon, status: :created, location: @text_verizon }
      else
        format.html { render action: "new" }
        format.json { render json: @text_verizon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /text_verizons/1
  # PUT /text_verizons/1.json
  def update
    @text_verizon = TextVerizon.find(params[:id])

    respond_to do |format|
      if @text_verizon.update_attributes(params[:text_verizon])
        format.html { redirect_to @text_verizon, notice: 'Text verizon was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @text_verizon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /text_verizons/1
  # DELETE /text_verizons/1.json
  def destroy
    @text_verizon = TextVerizon.find(params[:id])
    @text_verizon.destroy

    respond_to do |format|
      format.html { redirect_to text_verizons_url }
      format.json { head :no_content }
    end
  end
end
