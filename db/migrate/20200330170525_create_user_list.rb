class CreateUserList < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :slack_id
      t.string :display_name
      t.string :actual_name
      t.boolean :is_group
      t.boolean :is_deleted, :default => false
    end
    add_index :users, :slack_id, unique: true
  end
end
