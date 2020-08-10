class CreateExternalPaymentService
  attr_accessor :external_payment, :payment_amount, :currency

  Result = Struct.new(:id, :secret)

  def initialize(payment_amount:, currency:)
    @payment_amount = payment_amount
    @currency = currency
  end

  def call
    @external_payment = Stripe::PaymentIntent.create({
      amount: payment_amount,
      currency: currency,
      # forcing 3d secure for SCA whenever possible (not recommended by Stripe)
      payment_method_options: {card: {request_three_d_secure: 'any'}}
    })
    # only returning what we need, instead of the full object
    Result.new(external_payment.id, external_payment.client_secret)
  end

end
