class AddExternalPaymentIdToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :external_payment_id, :string
    add_index :orders, :external_payment_id
  end
end
