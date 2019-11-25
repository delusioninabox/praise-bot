class CreateView < ActiveRecord::Migration[5.2]
  def change
    create_table :views do |t|
      t.string :view_id
      t.string :slack_user_id
      t.string :emoji
      t.string :headline
      t.text :details
      t.text :user_selection, array: true
      t.text :value_selection, array: true
      t.boolean :posted, :default => false

      t.timestamps
    end
  end
end
