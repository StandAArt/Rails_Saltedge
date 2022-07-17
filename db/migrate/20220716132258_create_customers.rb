class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.string :identifier
      t.string :secret
      t.datetime :blocked_at
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
