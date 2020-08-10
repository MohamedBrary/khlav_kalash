class InitOrderService
  attr_accessor :order, :order_params, :external_payment_id, :external_payment_secret

  Result = Struct.new(:order, :external_payment_secret)

  def initialize(order_params={})
    @order_params = order_params

    external_payment = CreateExternalPaymentService.new(
      payment_amount: Order::UNIT_PRICE_CENTS,
      currency: Order::CURRENCY.downcase
    ).call
    @external_payment_id = external_payment.id
    @external_payment_secret = external_payment.secret
  end

  def call
    order_params[:amount_cents] = Order::UNIT_PRICE_CENTS
    order_params[:external_payment_id] = external_payment_id
    @order = Order.new(order_params)

    Result.new(order, external_payment_secret)
  end

end
