require 'test_helper'

class SaleReturnsControllerTest < ActionController::TestCase
  setup do
    @sale_return = sale_returns(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sale_returns)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sale_return" do
    assert_difference('SaleReturn.count') do
      post :create, sale_return: { cprice: @sale_return.cprice, price: @sale_return.price, product_id: @sale_return.product_id, qty: @sale_return.qty, sale_id: @sale_return.sale_id }
    end

    assert_redirected_to sale_return_path(assigns(:sale_return))
  end

  test "should show sale_return" do
    get :show, id: @sale_return
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sale_return
    assert_response :success
  end

  test "should update sale_return" do
    patch :update, id: @sale_return, sale_return: { cprice: @sale_return.cprice, price: @sale_return.price, product_id: @sale_return.product_id, qty: @sale_return.qty, sale_id: @sale_return.sale_id }
    assert_redirected_to sale_return_path(assigns(:sale_return))
  end

  test "should destroy sale_return" do
    assert_difference('SaleReturn.count', -1) do
      delete :destroy, id: @sale_return
    end

    assert_redirected_to sale_returns_path
  end
end
