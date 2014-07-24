require 'test_helper'

class SoldProductsControllerTest < ActionController::TestCase
  setup do
    @sold_product = sold_products(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sold_products)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sold_product" do
    assert_difference('SoldProduct.count') do
      post :create, sold_product: { cprice: @sold_product.cprice, price: @sold_product.price, product_id: @sold_product.product_id, purchase_product_id: @sold_product.purchase_product_id, sale_product_id: @sold_product.sale_product_id, stock_product_id: @sold_product.stock_product_id }
    end

    assert_redirected_to sold_product_path(assigns(:sold_product))
  end

  test "should show sold_product" do
    get :show, id: @sold_product
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sold_product
    assert_response :success
  end

  test "should update sold_product" do
    put :update, id: @sold_product, sold_product: { cprice: @sold_product.cprice, price: @sold_product.price, product_id: @sold_product.product_id, purchase_product_id: @sold_product.purchase_product_id, sale_product_id: @sold_product.sale_product_id, stock_product_id: @sold_product.stock_product_id }
    assert_redirected_to sold_product_path(assigns(:sold_product))
  end

  test "should destroy sold_product" do
    assert_difference('SoldProduct.count', -1) do
      delete :destroy, id: @sold_product
    end

    assert_redirected_to sold_products_path
  end
end
