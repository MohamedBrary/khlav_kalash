class CreateOrderService
  attr_accessor :order_params

  def initialize(order_params)
    @order_params = order_params
  end

  def call
    Order.create(order_params)
  end

end
