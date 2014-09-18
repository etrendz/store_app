require 'test_helper'

class VariantItemsControllerTest < ActionController::TestCase
  setup do
    @variant_item = variant_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:variant_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create variant_item" do
    assert_difference('VariantItem.count') do
      post :create, variant_item: { name: @variant_item.name, variant_id: @variant_item.variant_id }
    end

    assert_redirected_to variant_item_path(assigns(:variant_item))
  end

  test "should show variant_item" do
    get :show, id: @variant_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @variant_item
    assert_response :success
  end

  test "should update variant_item" do
    patch :update, id: @variant_item, variant_item: { name: @variant_item.name, variant_id: @variant_item.variant_id }
    assert_redirected_to variant_item_path(assigns(:variant_item))
  end

  test "should destroy variant_item" do
    assert_difference('VariantItem.count', -1) do
      delete :destroy, id: @variant_item
    end

    assert_redirected_to variant_items_path
  end
end
