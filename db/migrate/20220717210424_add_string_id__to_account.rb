class AddStringIdToAccount < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :account_string_id, :string
  end
end
