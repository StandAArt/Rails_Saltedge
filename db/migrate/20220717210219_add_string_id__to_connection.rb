class AddStringIdToConnection < ActiveRecord::Migration[7.0]
  def change
    add_column :connections, :connection_string_id, :string
  end
end
