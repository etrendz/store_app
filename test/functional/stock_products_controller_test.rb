require 'test_helper'

class StockProductsControllerTest < ActionController::TestCase
  setup do
    @stock_product = stock_products(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stock_products)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stock_product" do
    assert_difference('StockProduct.count') do
      post :create, stock_product: { price: @stock_product.price, product_id: @stock_product.product_id }
    end

    assert_redirected_to stock_product_path(assigns(:stock_product))
  end

  test "should show stock_product" do
    get :show, id: @stock_product
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @stock_product
    assert_response :success
  end

  test "should update stock_product" do
    put :update, id: @stock_product, stock_product: { price: @stock_product.price, product_id: @stock_product.product_id }
    assert_redirected_to stock_product_path(assigns(:stock_product))
  end

  test "should destroy stock_product" do
    assert_difference('StockProduct.count', -1) do
      delete :destroy, id: @stock_product
    end

    assert_redirected_to stock_products_path
  end
end
