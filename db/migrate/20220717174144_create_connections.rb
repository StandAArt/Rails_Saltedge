class CreateConnections < ActiveRecord::Migration[7.0]
  def change
    create_table :connections do |t|
      t.string :secret
      t.string :provider_id
      t.string :provider_code
      t.string :provider_name
      t.boolean :daily_refresh
      t.datetime :last_success_at
      t.string :status
      t.string :country_code
      t.datetime :next_refresh_possible_at
      t.string :store_credentials
      t.boolean :show_consent_confirmation
      t.string :last_consent_id
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
