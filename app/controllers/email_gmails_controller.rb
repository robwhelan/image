class EmailGmailsController < ApplicationController
  # GET /email_gmails
  # GET /email_gmails.json
  def index
    @email_gmails = EmailGmail.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @email_gmails }
    end
  end

  # GET /email_gmails/1
  # GET /email_gmails/1.json
  def show
    @email_gmail = EmailGmail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @email_gmail }
    end
  end

  # GET /email_gmails/new
  # GET /email_gmails/new.json
  def new
    @email_gmail = EmailGmail.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @email_gmail }
    end
  end

  # GET /email_gmails/1/edit
  def edit
    @email_gmail = EmailGmail.find(params[:id])
  end

  # POST /email_gmails
  # POST /email_gmails.json
  def create
    @email_gmail = EmailGmail.new(params[:email_gmail])

    respond_to do |format|
      if @email_gmail.save
        format.html { redirect_to @email_gmail, notice: 'Email gmail was successfully created.' }
        format.json { render json: @email_gmail, status: :created, location: @email_gmail }
      else
        format.html { render action: "new" }
        format.json { render json: @email_gmail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /email_gmails/1
  # PUT /email_gmails/1.json
  def update
    @email_gmail = EmailGmail.find(params[:id])

    respond_to do |format|
      if @email_gmail.update_attributes(params[:email_gmail])
        format.html { redirect_to @email_gmail, notice: 'Email gmail was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @email_gmail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /email_gmails/1
  # DELETE /email_gmails/1.json
  def destroy
    @email_gmail = EmailGmail.find(params[:id])
    @email_gmail.destroy

    respond_to do |format|
      format.html { redirect_to email_gmails_url }
      format.json { head :no_content }
    end
  end
end
