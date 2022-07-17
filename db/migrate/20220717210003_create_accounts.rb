class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :nature
      t.float :balance
      t.string :currency_code
      t.string :cards
      t.integer :posted_transactions_count
      t.integer :pending_transactions_count
      t.references :connection, null: false, foreign_key: true

      t.timestamps
    end
  end
end
