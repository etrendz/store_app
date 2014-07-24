require 'test_helper'

class PurchaseProductsControllerTest < ActionController::TestCase
  setup do
    @purchase_product = purchase_products(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:purchase_products)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create purchase_product" do
    assert_difference('PurchaseProduct.count') do
      post :create, purchase_product: { price: @purchase_product.price, product_id: @purchase_product.product_id, purchase_id: @purchase_product.purchase_id, qty: @purchase_product.qty }
    end

    assert_redirected_to purchase_product_path(assigns(:purchase_product))
  end

  test "should show purchase_product" do
    get :show, id: @purchase_product
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @purchase_product
    assert_response :success
  end

  test "should update purchase_product" do
    put :update, id: @purchase_product, purchase_product: { price: @purchase_product.price, product_id: @purchase_product.product_id, purchase_id: @purchase_product.purchase_id, qty: @purchase_product.qty }
    assert_redirected_to purchase_product_path(assigns(:purchase_product))
  end

  test "should destroy purchase_product" do
    assert_difference('PurchaseProduct.count', -1) do
      delete :destroy, id: @purchase_product
    end

    assert_redirected_to purchase_products_path
  end
end
