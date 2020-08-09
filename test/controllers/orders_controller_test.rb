require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:one)
  end

  test "should get index" do
    get orders_url, headers: headers
    assert_response :success
  end

  test "should get new" do
    get new_order_url
    assert_response :success
  end

  test "should create order" do
    order_params = @order.as_json.except('id', 'created_at', 'updated_at')
    @order.destroy # to avoid uniqueness violations
    assert_difference('Order.count') do
      post orders_url, params: { order: order_params }
    end

    assert_redirected_to order_permalink_url(Order.last.permalink)
  end

  test "should show order" do
    get order_url(@order), headers: headers
    assert_response :success
  end

  test "should get edit" do
    get edit_order_url(@order), headers: headers
    assert_response :success
  end

  test "should update order" do
    order_params = @order.as_json.except('id', 'created_at', 'updated_at')
    patch order_url(@order), headers: headers, params: { order: order_params }
    assert_redirected_to order_url(@order)
  end

  test "should destroy order" do
    assert_difference('Order.count', -1) do
      delete order_url(@order), headers: headers
    end

    assert_redirected_to orders_url
  end

  private

  def headers
    return @headers if @headers
    username = ENV['ADMIN_USER_NAME']
    password = ENV['ADMIN_PASSWORD']
    # for more info:
    # https://github.com/rack/rack-test/blob/master/lib/rack/test.rb#L166
    encoded_login = ["#{username}:#{password}"].pack('m0')
    @headers = {Authorization: "Basic #{encoded_login}"}
  end
end
