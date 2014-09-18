class VariantsController < ApplicationController
  before_action :set_variant, only: [:show, :edit, :update, :destroy]

  # GET /variants
  def index
    @variants = Variant.all
  end

  # GET /variants/1
  def show
  end

  # GET /variants/new
  def new
    @variant = Variant.new
  end

  # GET /variants/1/edit
  def edit
  end

  # POST /variants
  def create
    @variant = Variant.new(variant_params)

    if @variant.save
      redirect_to @variant, notice: 'Variant was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /variants/1
  def update
    if @variant.update(variant_params)
      redirect_to @variant, notice: 'Variant was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /variants/1
  def destroy
    @variant.destroy
    redirect_to variants_url, notice: 'Variant was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_variant
      @variant = Variant.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def variant_params
      params.require(:variant).permit(:name)
    end
end
