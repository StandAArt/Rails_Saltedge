class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.string :mode
      t.string :status
      t.datetime :made_on
      t.float :amount
      t.string :currency_code
      t.string :description
      t.string :category
      t.boolean :duplicated
      t.string :merchant_id
      t.float :original_amount
      t.string :original_currency_code
      t.datetime :posting_date
      t.datetime :time
      t.string :string
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
