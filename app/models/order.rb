class Order < ApplicationRecord
  before_create :set_defaults

  validates :first_name, :country, :postal_code, :email_address, presence: true
  # this validator uses a loose regex to validate, something like: '\w+@\w+'
  validates :email_address, email: true

  UNIT_PRICE_CENTS = 299
  CURRENCY = 'USD'.freeze

  def price
    Money.new(UNIT_PRICE_CENTS, CURRENCY)
  end

  # trim email spaces
  def email_address=(email)
    email = email.strip if email
    super(email)
  end

  private

  def set_defaults
    self.number = next_number
    self.permalink = SecureRandom.hex(20)

    while Order.where(permalink: self.permalink).any?
      self.permalink = SecureRandom.hex(20)
    end
  end

  def next_number
    current = self.class.reorder('number desc').first.try(:number) || '000000000000'
    current.next
  end
end
