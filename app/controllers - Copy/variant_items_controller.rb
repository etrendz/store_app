class VariantItemsController < ApplicationController
  before_action :set_variant_item, only: [:show, :edit, :update, :destroy]

  # GET /variant_items
  def index
    @variant_items = VariantItem.all
  end

  # GET /variant_items/1
  def show
  end

  # GET /variant_items/new
  def new
    @variant_item = VariantItem.new
  end

  # GET /variant_items/1/edit
  def edit
  end

  # POST /variant_items
  def create
    @variant_item = VariantItem.new(variant_item_params)

    if @variant_item.save
      redirect_to @variant_item, notice: 'Variant item was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /variant_items/1
  def update
    if @variant_item.update(variant_item_params)
      redirect_to @variant_item, notice: 'Variant item was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /variant_items/1
  def destroy
    @variant_item.destroy
    redirect_to variant_items_url, notice: 'Variant item was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_variant_item
      @variant_item = VariantItem.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def variant_item_params
      params.require(:variant_item).permit(:name, :variant_id)
    end
end
