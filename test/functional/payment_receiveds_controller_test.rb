require 'test_helper'

class PaymentReceivedsControllerTest < ActionController::TestCase
  setup do
    @payment_received = payment_receiveds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:payment_receiveds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create payment_received" do
    assert_difference('PaymentReceived.count') do
      post :create, payment_received: { customer_id: @payment_received.customer_id, payment: @payment_received.payment }
    end

    assert_redirected_to payment_received_path(assigns(:payment_received))
  end

  test "should show payment_received" do
    get :show, id: @payment_received
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @payment_received
    assert_response :success
  end

  test "should update payment_received" do
    put :update, id: @payment_received, payment_received: { customer_id: @payment_received.customer_id, payment: @payment_received.payment }
    assert_redirected_to payment_received_path(assigns(:payment_received))
  end

  test "should destroy payment_received" do
    assert_difference('PaymentReceived.count', -1) do
      delete :destroy, id: @payment_received
    end

    assert_redirected_to payment_receiveds_path
  end
end
