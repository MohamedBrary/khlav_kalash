# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# for more info: https://stackoverflow.com/a/40235869/426845
document.addEventListener 'turbolinks:load', ->
  form = document.getElementById('payment-form')
  return unless form
  clientSecret = form.dataset['secret']
  return unless clientSecret

  # Source: https://stripe.com/docs/stripe-js
  # Create a Stripe client.
  stripe = Stripe('pk_test_51HEJrAJdSbd5YG6LJdf6CPWBNbKXB1ec4PeAzow4Q4A54aoDTtMsHT9vrg4Ze8wvbJfl2b8jwLGyXrnwDqcd5hSA00X1FFIyIu')
  # Create an instance of Elements.
  elements = stripe.elements()
  # Custom styling can be passed to options when creating an Element.
  # (Note that this demo uses a wider set of styles than the guide below.)
  style =
    base:
      color: '#32325d'
      fontFamily: '"Helvetica Neue", Helvetica, sans-serif'
      fontSmoothing: 'antialiased'
      fontSize: '16px'
      '::placeholder': color: '#aab7c4'
    invalid:
      color: '#fa755a'
      iconColor: '#fa755a'
  # Create an instance of the card Element.
  card = elements.create('card', style: style)

  extractBillingInfo = () ->
    email_address = document.getElementsByName('order[email_address]')[0].value
    first_name = document.getElementsByName('order[first_name]')[0].value
    last_name = document.getElementsByName('order[last_name]')[0].value
    name = "#{first_name} #{last_name}"
    city = document.getElementsByName('order[city]')[0].value
    country = document.getElementsByName('order[country]')[0].value
    street_line_1 = document.getElementsByName('order[street_line_1]')[0].value
    street_line_2 = document.getElementsByName('order[street_line_2]')[0].value
    postal_code = document.getElementsByName('order[postal_code]')[0].value
    state = document.getElementsByName('order[region]')[0].value

    # Info needed for SCA
    # https://stripe.com/docs/api/payment_intents/confirm
    {
      name: name,
      email: email_address,
      address: {
        city: city,
        country: country,
        line1: street_line_1,
        line2: street_line_2,
        postal_code: postal_code,
        state: state,
      }
    }

  card.mount '#card-element'

  # Handle real-time validation errors from the card Element.
  card.on 'change', (event) ->
    displayError = document.getElementById('card-errors')
    if event.error
      displayError.textContent = event.error.message
    else
      displayError.textContent = ''
    return

  # Handle form submission.
  form.addEventListener 'submit', (ev) ->
    # skip if no payment rendered
    clientSecret = form.dataset['secret']
    return true unless clientSecret

    document.getElementsByName('commit')[0].disabled = true
    ev.preventDefault()
    ev.stopPropagation()

    # extract order info and send it with payment, to increase chances of acceptance
    billing_info = extractBillingInfo()
    stripe.confirmCardPayment(clientSecret, {
      payment_method: {
        card: card,
        billing_details: billing_info
      },
      receipt_email: billing_info['email']
    }).then (result) ->
      if result.error
        # Show error to your customer (e.g., insufficient funds)
        console.log result.error.message
        alert "Payment Error: #{result.error.message}"
        document.getElementsByName('commit')[0].disabled = false
        return false
      else
        # The payment has been processed!
        if result.paymentIntent.status == 'succeeded'
          # Show a success message to your customer
          # There's a risk of the customer closing the window before callback
          # execution. Set up a webhook or plugin to listen for the
          # payment_intent.succeeded event that handles any business critical
          # post-payment actions.
          alert 'Payment succeeded!'
          # not needed, as we already have the intent id
          document.getElementsByName('order[external_payment_id]')[0].value = result.paymentIntent.id
          form.submit()
        else
          alert 'Payment failed!'
        return false

      return false
    return false
