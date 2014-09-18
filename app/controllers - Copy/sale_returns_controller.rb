class SaleReturnsController < ApplicationController
  before_action :set_sale_return, only: [:show, :edit, :update, :destroy]

  # GET /sale_returns
  def index
    @sale_returns = SaleReturn.all
  end

  # GET /sale_returns/1
  def show
  end

  # GET /sale_returns/new
  def new
    @sale_return = SaleReturn.new
  end

  # GET /sale_returns/1/edit
  def edit
  end

  # POST /sale_returns
  def create
    @sale_return = SaleReturn.new(sale_return_params)

    if @sale_return.save
      redirect_to @sale_return, notice: 'Sale return was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /sale_returns/1
  def update
    if @sale_return.update(sale_return_params)
      redirect_to @sale_return, notice: 'Sale return was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /sale_returns/1
  def destroy
    @sale_return.destroy
    redirect_to sale_returns_url, notice: 'Sale return was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale_return
      @sale_return = SaleReturn.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def sale_return_params
      params.require(:sale_return).permit(:sale_id, :product_id, :qty, :cprice, :price)
    end
end
