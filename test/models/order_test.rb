require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  test 'presence validation' do
    order = Order.new
    order.validate

    mandatory_fields = [:first_name, :country, :postal_code, :email_address]
    mandatory_fields.each do |field|
      assert has_validation_error?(order, field, :blank), "test presence validation of #{field} failed"
    end
  end

  test 'email validation' do
    order = Order.new
    invalid_email_values = [nil, '', '@', 'first@', '@last']
    invalid_email_values.each do |invalid_email|
      order.email_address = invalid_email
      order.validate

      assert has_validation_error?(order, :email_address, :invalid), "test email validation with value #{invalid_email} failed"
    end
    order.email_address = 'valid@email.com'
    order.validate

    refute has_validation_error?(order, :email_address, :invalid)
  end

  private

  def has_validation_error?(model, attribute, kind = nil)
    if kind
      model.errors.details[attribute].any? { |error_detail| error_detail[:error] == kind }
    else
      model.errors[attribute].any?
    end
  end
end
