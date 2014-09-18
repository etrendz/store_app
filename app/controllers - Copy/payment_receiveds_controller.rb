class PaymentReceivedsController < ApplicationController
  before_filter :require_login
  # GET /payment_receiveds
  # GET /payment_receiveds.json
  def index
    @payment_receiveds = PaymentReceived.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @payment_receiveds }
    end
  end

  # GET /payment_receiveds/1
  # GET /payment_receiveds/1.json
  def show
    @payment_received = PaymentReceived.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @payment_received }
    end
  end

  # GET /payment_receiveds/new
  # GET /payment_receiveds/new.json
  def new
    @payment_received = PaymentReceived.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @payment_received }
    end
  end

  # GET /payment_receiveds/1/edit
  def edit
    @payment_received = PaymentReceived.find(params[:id])
  end

  # POST /payment_receiveds
  # POST /payment_receiveds.json
  def create
    @payment_received = PaymentReceived.new(params[:payment_received])

    respond_to do |format|
      if @payment_received.save
        format.html { redirect_to @payment_received, notice: 'Payment received was successfully created.' }
        format.json { render json: @payment_received, status: :created, location: @payment_received }
      else
        format.html { render action: "new" }
        format.json { render json: @payment_received.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /payment_receiveds/1
  # PUT /payment_receiveds/1.json
  def update
    @payment_received = PaymentReceived.find(params[:id])

    respond_to do |format|
      if @payment_received.update_attributes(params[:payment_received])
        format.html { redirect_to @payment_received, notice: 'Payment received was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @payment_received.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_receiveds/1
  # DELETE /payment_receiveds/1.json
  def destroy
    @payment_received = PaymentReceived.find(params[:id])
    @payment_received.destroy

    respond_to do |format|
      format.html { redirect_to payment_receiveds_url }
      format.json { head :no_content }
    end
  end
end
