class AddStringIdToCustomer < ActiveRecord::Migration[7.0]
  def change
    add_column :customers, :customer_string_id, :string
  end
end
