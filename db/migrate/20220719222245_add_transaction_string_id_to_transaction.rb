class AddTransactionStringIdToTransaction < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :transaction_string_id, :string
  end
end
